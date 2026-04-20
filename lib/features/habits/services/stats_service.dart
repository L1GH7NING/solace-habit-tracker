import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
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

  // ── Helper ─────────────────────────────────────────────────────────────────

  double targetOn(
    DateTime date,
    List<HabitTargetHistoryData> history,
    double fallback,
  ) {
    // print(
    //   'History rows: ${history.map((h) => 'effectiveFrom=${h.effectiveFrom}, target=${h.targetValue}').toList()}',
    // );
    // print('Checking date: $date, fallback: $fallback');
    final applicable =
        history.where((h) => !h.effectiveFrom.isAfter(date)).toList()
          ..sort((a, b) => b.effectiveFrom.compareTo(a.effectiveFrom));
    return applicable.isEmpty ? fallback : applicable.first.targetValue;
  }

  // ── Per-habit stats ────────────────────────────────────────────────────────

  Stream<HabitStats> watchHabitStats(Habit habit) {
    final completionsQuery = db.select(db.habitCompletions)
      ..where((tbl) => tbl.habitId.equals(habit.id));
    final historyQuery = db.select(db.habitTargetHistory)
      ..where((tbl) => tbl.habitId.equals(habit.id));

    return Rx.combineLatest2(
      completionsQuery.watch(),
      historyQuery.watch(),
      (
        List<HabitCompletion> completions,
        List<HabitTargetHistoryData> history,
      ) => _calculateStats(habit, completions, history),
    );
  }

  HabitStats _calculateStats(
    Habit habit,
    List<HabitCompletion> completions,
    List<HabitTargetHistoryData> history,
  ) {
    final today = _dateOnly(DateTime.now());

    DateTime start = _dateOnly(habit.startDate);
    if (habit.frequencyType == 'WEEKLY') start = _startOfWeek(start);

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

    final todayKey = habit.frequencyType == 'WEEKLY'
        ? _startOfWeek(today)
        : today;
    final todayValue = progressMap[todayKey] ?? 0.0;

    bool isDoneOn(DateTime date) {
      final progress = progressMap[date] ?? 0;
      final target = targetOn(date, history, habit.targetValue);
      return progress >= target;
    }

    List<DateTime> applicableDates = [];
    DateTime current = start;
    if (progressMap.isNotEmpty) {
      final firstLog = progressMap.keys.reduce((a, b) => a.isBefore(b) ? a : b);
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

    int bestStreak = 0, tempStreak = 0, daysMetTarget = 0;
    for (var date in applicableDates) {
      if (isDoneOn(date)) {
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
      if (isDoneOn(date)) {
        currentStreak++;
      } else {
        if (!isGracePeriod(date)) break;
      }
    }

    final compRate = applicableDates.isEmpty
        ? 0.0
        : daysMetTarget / applicableDates.length;

    final last7DaysProgress = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final key = habit.frequencyType == 'WEEKLY' ? _startOfWeek(day) : day;
      final val = progressMap[key] ?? 0;
      final target = targetOn(key, history, habit.targetValue);
      return target > 0 ? (val / target).clamp(0.0, 1.0) : 0.0;
    });

    final last7DaysCompletion = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final key = habit.frequencyType == 'WEEKLY' ? _startOfWeek(day) : day;
      return isDoneOn(key);
    });

    Map<DateTime, bool> weeklyCompletionMap = {};
    if (habit.frequencyType == 'WEEKLY') {
      final thisMonday = _startOfWeek(today);
      for (int i = 0; i < 5; i++) {
        final monday = thisMonday.subtract(Duration(days: (4 - i) * 7));
        weeklyCompletionMap[monday] = isDoneOn(monday);
      }
    }

    return HabitStats(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalDone: daysMetTarget,
      completionRate: compRate,
      last7DaysProgress: last7DaysProgress,
      todayValue: todayValue,
      last7DaysCompletion: last7DaysCompletion,
      weeklyCompletionMap: weeklyCompletionMap,
    );
  }

  // ── Perfect streak ─────────────────────────────────────────────────────────

  Stream<PerfectStreakResult> watchPerfectStreak(String userId) {
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {db.habits, db.habitCompletions, db.habitTargetHistory},
        )
        .watch()
        .asyncMap((_) => getPerfectStreak(userId));
  }

  Future<PerfectStreakResult> getPerfectStreak(String userId) async {
    final today = _dateOnly(DateTime.now());

    final allHabits =
        await (db.select(db.habits)..where(
              (h) =>
                  h.userId.equals(userId) &
                  h.isArchived.equals(false) &
                  h.frequencyType.equals('DAILY'),
            ))
            .get();

    if (allHabits.isEmpty) {
      return PerfectStreakResult(
        currentStreak: 0,
        bestStreak: 0,
        last7Days: List.filled(7, false),
      );
    }

    final allCompletions = await (db.select(
      db.habitCompletions,
    )..where((c) => c.userId.equals(userId))).get();

    final allHistory = await db.getTargetHistoryForUser(userId);
    final historyByHabit = <int, List<HabitTargetHistoryData>>{};
    for (final h in allHistory) {
      historyByHabit
          .putIfAbsent(h.habitId, () => <HabitTargetHistoryData>[])
          .add(h);
    }

    final Map<int, Map<DateTime, double>> completionsByHabit = {};
    for (final c in allCompletions) {
      final day = _dateOnly(c.completedAt);
      completionsByHabit.putIfAbsent(c.habitId, () => {})[day] =
          (completionsByHabit[c.habitId]![day] ?? 0) + c.value;
    }

    final earliestStart = allHabits
        .map((h) => _dateOnly(h.startDate))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    bool isPerfectDay(DateTime date) {
      if (date.isBefore(earliestStart)) return false;

      final scheduled = allHabits.where((h) {
        final start = _dateOnly(h.startDate);
        if (date.isBefore(start)) return false;
        if (h.endDate != null && date.isAfter(_dateOnly(h.endDate!))) {
          return false;
        }
        return _appliesOnDate(h, date);
      }).toList();

      if (scheduled.isEmpty) return false;

      return scheduled.every((h) {
        final progress = completionsByHabit[h.id]?[date] ?? 0.0;
        final target = targetOn(
          date,
          historyByHabit[h.id] ?? <HabitTargetHistoryData>[],
          h.targetValue,
        );
        return progress >= target;
      });
    }

    int bestStreak = 0, tempStreak = 0;
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
      final clean = daysString
          .replaceAll(RegExp(r'[^a-zA-Z,]'), '')
          .toUpperCase();
      final days = clean.split(',');
      const map = {
        1: 'MON',
        2: 'TUE',
        3: 'WED',
        4: 'THU',
        5: 'FRI',
        6: 'SAT',
        7: 'SUN',
      };
      return days.contains(map[date.weekday]);
    }
    return true;
  }
}
