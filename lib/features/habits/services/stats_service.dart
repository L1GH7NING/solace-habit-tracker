import 'package:drift/drift.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';

class HabitStats {
  final int currentStreak;
  final int bestStreak;
  final int totalDone;
  final double completionRate;
  final List<double> last7DaysProgress;
  final double todayValue;
  final List<bool> last7DaysCompletion;
  final Map<DateTime, bool> weeklyCompletionMap;

  HabitStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.totalDone,
    required this.completionRate,
    required this.last7DaysProgress,
    required this.todayValue,
    required this.last7DaysCompletion,
    this.weeklyCompletionMap = const {},
  });
}

class PerfectStreakResult {
  final int currentStreak;
  final int bestStreak;
  final List<bool> last7Days;

  const PerfectStreakResult({
    required this.currentStreak,
    required this.bestStreak,
    required this.last7Days,
  });
}

class StatsService {
  final AppDatabase db;
  StatsService(this.db);

  // ── Per-habit stats ────────────────────────────────────────────────────────

  Stream<HabitStats> watchHabitStats(Habit habit) {
    final query = db.select(db.habitCompletions)
      ..where((tbl) => tbl.habitId.equals(habit.id));
    return query.watch().map(
      (completions) => _calculateStats(habit, completions),
    );
  }

  HabitStats _calculateStats(Habit habit, List<HabitCompletion> completions) {
    final today = _dateOnly(DateTime.now());

    DateTime start = _dateOnly(habit.startDate);
    if (habit.frequencyType == 'WEEKLY') start = _startOfWeek(start);

    final totalDone =
        completions.fold<double>(0, (sum, c) => sum + c.value).toInt();

    final progressMap = <DateTime, double>{};
    for (var c in completions) {
      final d = _dateOnly(c.completedAt);
      if (habit.frequencyType == 'WEEKLY') {
        final monday = _startOfWeek(d);
        progressMap[monday] = (progressMap[monday] ?? 0) + c.value;
      } else {
        progressMap[d] = (progressMap[d] ?? 0) + c.value;
      }
    }

    final todayValue = habit.frequencyType == 'WEEKLY'
        ? (progressMap[_startOfWeek(today)] ?? 0.0)
        : (progressMap[today] ?? 0.0);

    List<DateTime> applicableDates = [];
    DateTime current = start;
    if (progressMap.isNotEmpty) {
      final firstLog =
          progressMap.keys.reduce((a, b) => a.isBefore(b) ? a : b);
      if (firstLog.isBefore(current)) current = firstLog;
    }
    while (!current.isAfter(today)) {
      if (habit.frequencyType == 'WEEKLY') {
        if (current.weekday == 1) applicableDates.add(current);
      } else {
        if (_appliesOnDate(habit, current)) applicableDates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    bool isGracePeriod(DateTime date) {
      if (habit.frequencyType == 'WEEKLY') {
        return date.isAtSameMomentAs(_startOfWeek(today));
      }
      return date.isAtSameMomentAs(today);
    }

    int bestStreak = 0;
    int tempStreak = 0;
    int daysMetTarget = 0;
    for (var date in applicableDates) {
      final isDone = (progressMap[date] ?? 0) >= habit.targetValue;
      if (isDone) {
        daysMetTarget++;
        tempStreak++;
        if (tempStreak > bestStreak) bestStreak = tempStreak;
      } else {
        if (!isGracePeriod(date)) tempStreak = 0;
      }
    }

    int currentStreak = 0;
    for (int i = applicableDates.length - 1; i >= 0; i--) {
      final date = applicableDates[i];
      final isDone = (progressMap[date] ?? 0) >= habit.targetValue;
      if (isDone) {
        currentStreak++;
      } else {
        if (!isGracePeriod(date)) break;
      }
    }

    final compRate =
        applicableDates.isEmpty ? 0.0 : daysMetTarget / applicableDates.length;

    final last7DaysProgress = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final val = habit.frequencyType == 'WEEKLY'
          ? (progressMap[_startOfWeek(day)] ?? 0)
          : (progressMap[day] ?? 0);
      return habit.targetValue > 0
          ? (val / habit.targetValue).clamp(0.0, 1.0)
          : 0.0;
    });

    final last7DaysCompletion = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final val = habit.frequencyType == 'WEEKLY'
          ? (progressMap[_startOfWeek(day)] ?? 0)
          : (progressMap[day] ?? 0);
      return val >= habit.targetValue;
    });

    Map<DateTime, bool> weeklyCompletionMap = {};
    if (habit.frequencyType == 'WEEKLY') {
      final thisMonday = _startOfWeek(today);
      for (int i = 0; i < 5; i++) {
        final monday = thisMonday.subtract(Duration(days: (4 - i) * 7));
        weeklyCompletionMap[monday] =
            (progressMap[monday] ?? 0) >= habit.targetValue;
      }
    }

    return HabitStats(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalDone: totalDone,
      completionRate: compRate,
      last7DaysProgress: last7DaysProgress,
      todayValue: todayValue,
      last7DaysCompletion: last7DaysCompletion,
      weeklyCompletionMap: weeklyCompletionMap,
    );
  }

  // ── Perfect streak (cross-habit, DAILY only) ──────────────────────────────

  Stream<PerfectStreakResult> watchPerfectStreak(String userId) {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {db.habits, db.habitCompletions},
        )
        .watch()
        .asyncMap((_) => getPerfectStreak(userId));
  }

  Future<PerfectStreakResult> getPerfectStreak(String userId) async {
    final today = _dateOnly(DateTime.now());

    // ✅ Only DAILY habits count — weekly habits are intentionally excluded
    final allHabits = await (db.select(db.habits)
          ..where((h) =>
              h.userId.equals(userId) &
              h.isArchived.equals(false) &
              h.frequencyType.equals('DAILY')))
        .get();

    if (allHabits.isEmpty) {
      return PerfectStreakResult(
        currentStreak: 0,
        bestStreak: 0,
        last7Days: List.filled(7, false),
      );
    }

    // Load all completions for this user
    final allCompletions = await (db.select(db.habitCompletions)
          ..where((c) => c.userId.equals(userId)))
        .get();

    // Map: habitId → { date → total value logged that day }
    final Map<int, Map<DateTime, double>> completionsByHabit = {};
    for (final c in allCompletions) {
      final day = _dateOnly(c.completedAt);
      completionsByHabit.putIfAbsent(c.habitId, () => {})[day] =
          (completionsByHabit[c.habitId]![day] ?? 0) + c.value;
    }

    // Earliest date we care about = earliest habit start date
    // We do NOT push this back based on completions — a habit doesn't
    // exist before its start date regardless of back-dated logs.
    final earliestStart = allHabits
        .map((h) => _dateOnly(h.startDate))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    // ✅ Returns true only when ALL habits that are:
    //    1. Started on or before `date`
    //    2. Not ended before `date`
    //    3. Scheduled on this weekday (frequencyDays)
    // …have been completed to their target.
    // Returns false (not true) when no habits are scheduled — prevents
    // empty days and days before any habit existed from counting.
    bool isPerfectDay(DateTime date) {
      // Never count days before the earliest habit started
      if (date.isBefore(earliestStart)) return false;

      final scheduled = allHabits.where((h) {
        final start = _dateOnly(h.startDate);

        // ✅ Only include habits that have actually started by this date.
        // Back-dated completions don't make a habit "exist" earlier.
        if (date.isBefore(start)) return false;

        // Skip archived or ended habits
        if (h.endDate != null && date.isAfter(_dateOnly(h.endDate!))) {
          return false;
        }

        // Must apply on this weekday (handles frequencyDays for DAILY habits
        // that are only scheduled on certain days)
        return _appliesOnDate(h, date);
      }).toList();

      // ✅ If no habits are scheduled this day, it is NOT a perfect day.
      // This prevents gaps (e.g. no habits on a weekend) from padding streaks.
      if (scheduled.isEmpty) return false;

      // ✅ Every scheduled habit must meet its target
      return scheduled.every((h) {
        final progress = completionsByHabit[h.id]?[date] ?? 0.0;
        return progress >= h.targetValue;
      });
    }

    // ── Best streak (forward pass) ────────────────────────────────────────
    int bestStreak = 0;
    int tempStreak = 0;
    DateTime day = earliestStart;
    while (!day.isAfter(today)) {
      if (isPerfectDay(day)) {
        tempStreak++;
        if (tempStreak > bestStreak) bestStreak = tempStreak;
      } else {
        tempStreak = 0;
      }
      day = day.add(const Duration(days: 1));
    }

    // ── Current streak (backward pass) ───────────────────────────────────
    // Start from yesterday if today isn't complete yet — grace period
    // means an in-progress today doesn't break an active streak.
    int currentStreak = 0;
    day = isPerfectDay(today) ? today : today.subtract(const Duration(days: 1));

    while (!day.isBefore(earliestStart)) {
      if (isPerfectDay(day)) {
        currentStreak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // ── Last 7 days ───────────────────────────────────────────────────────
    final last7Days = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return isPerfectDay(d);
    });

    return PerfectStreakResult(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      last7Days: last7Days,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime _startOfWeek(DateTime date) =>
      _dateOnly(date.subtract(Duration(days: date.weekday - 1)));

  bool _appliesOnDate(Habit habit, DateTime date) {
    final daysString = habit.frequencyDays ?? '';
    if (daysString.trim().isNotEmpty) {
      final clean =
          daysString.replaceAll(RegExp(r'[^a-zA-Z,]'), '').toUpperCase();
      final days = clean.split(',');
      const map = {
        1: 'MON', 2: 'TUE', 3: 'WED',
        4: 'THU', 5: 'FRI', 6: 'SAT', 7: 'SUN',
      };
      return days.contains(map[date.weekday]);
    }
    return true;
  }
}