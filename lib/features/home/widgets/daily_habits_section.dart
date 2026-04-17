import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/router/route_observer.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart';
import 'package:zenith_habit_tracker/features/home/widgets/habit_card/habit_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/perfect_streak_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/progress_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/section_header.dart';
import 'package:intl/intl.dart';

class DailyHabitsSection extends StatefulWidget {
  final List<Habit> dailyHabits;
  final List<HabitCompletion> dailyCompletions;
  final String userId;
  final DateTime selectedDate;
  final bool isToday;
  final bool canLog;
  final bool canJournal;

  const DailyHabitsSection({
    super.key,
    required this.dailyHabits,
    required this.dailyCompletions,
    required this.userId,
    required this.selectedDate,
    required this.isToday,
    this.canLog = true,
    this.canJournal = true,
  });

  @override
  State<DailyHabitsSection> createState() => _DailyHabitsSectionState();
}

class _DailyHabitsSectionState extends State<DailyHabitsSection>
    with RouteAware, WidgetsBindingObserver {
  List<Habit> _stableOrder = [];
  String? _lastDateKey;

  // ✅ Set to true while the user is actively logging in this session.
  // Prevents a completion-driven didUpdateWidget from re-sorting mid-tap.
  bool _isActivelyLogging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _stableOrder = _initialSort(widget.dailyHabits, widget.dailyCompletions);
    _lastDateKey = _dateKey(widget.selectedDate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route events (safe to call multiple times)
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ─── RouteAware ───────────────────────────────────────────────────────────

  /// Called when the user pops back to this route from a child route.
  @override
  void didPopNext() => _resortNow();

  // ─── WidgetsBindingObserver ───────────────────────────────────────────────

  /// Called when the app resumes from background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _resortNow();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  void _resortNow() {
    if (!mounted) return;
    setState(() {
      _stableOrder = _initialSort(widget.dailyHabits, widget.dailyCompletions);
    });
  }

  @override
  void didUpdateWidget(DailyHabitsSection old) {
    super.didUpdateWidget(old);

    final newDateKey = _dateKey(widget.selectedDate);
    final dateChanged = newDateKey != _lastDateKey;
    final habitsChanged = _habitsListChanged(old.dailyHabits, widget.dailyHabits);

    if (dateChanged || habitsChanged) {
      setState(() {
        _stableOrder = _initialSort(widget.dailyHabits, widget.dailyCompletions);
        _lastDateKey = newDateKey;
      });
      return;
    }

    // ✅ Completions changed but we're mid-session: only re-sort if nothing
    // is actively being logged (i.e. this is a background/external update).
    if (!_isActivelyLogging &&
        _completionsChanged(old.dailyCompletions, widget.dailyCompletions)) {
      _resortNow();
    }
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  bool _habitsListChanged(List<Habit> old, List<Habit> next) {
    if (old.length != next.length) return true;
    final oldIds = old.map((h) => h.id).toSet();
    return !next.every((h) => oldIds.contains(h.id));
  }

  bool _completionsChanged(
    List<HabitCompletion> old,
    List<HabitCompletion> next,
  ) {
    if (old.length != next.length) return true;
    final oldMap = {for (final c in old) c.habitId: c.value};
    return next.any((c) => oldMap[c.habitId] != c.value);
  }

  List<Habit> _initialSort(
    List<Habit> habits,
    List<HabitCompletion> completions,
  ) {
    return List<Habit>.from(habits)
      ..sort((a, b) {
        final isCompletedA = _progressFor(a, completions) >= a.targetValue;
        final isCompletedB = _progressFor(b, completions) >= b.targetValue;
        if (isCompletedA != isCompletedB) return isCompletedA ? 1 : -1;

        final timeA = a.habitTime;
        final timeB = b.habitTime;
        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeA.compareTo(timeB);
      });
  }

  double _progressFor(Habit habit, List<HabitCompletion> completions) =>
      completions
          .where((c) => c.habitId == habit.id)
          .fold<double>(0.0, (sum, c) => sum + c.value);

  double _currentProgressFor(Habit habit) =>
      _progressFor(habit, widget.dailyCompletions);

  @override
  Widget build(BuildContext context) {
    final appDb = Provider.of<AppDatabase>(context, listen: false);
    final habitService = HabitService(appDb);
    final journalService = JournalService(appDb);

    final completedCount = widget.dailyHabits
        .where((h) => _currentProgressFor(h) >= h.targetValue)
        .length;

    final formattedDate = DateFormat('MMMM d').format(widget.selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ProgressCard(
                completed: completedCount,
                total: widget.dailyHabits.length,
                isToday: widget.isToday,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<PerfectStreakResult>(
                stream: StatsService(appDb).watchPerfectStreak(widget.userId),
                builder: (context, streakSnap) =>
                    PerfectStreakCard(result: streakSnap.data),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionHeader(
          title: widget.isToday
              ? "Today's Habits"
              : "Habits for $formattedDate",
        ),
        const SizedBox(height: 12),

        for (final habit in _stableOrder)
          RepaintBoundary(
            key: ValueKey(habit.id),
            child: HabitCard(
              habit: habit,
              currentProgress: _currentProgressFor(habit),
              canLog: widget.canLog,
              canJournal: widget.canJournal,
              onTap: () => context.push('/habit-info/${habit.id}'),
              onLog: (v) async {
                // ✅ Flag that we're logging so didUpdateWidget doesn't re-sort
                _isActivelyLogging = true;
                try {
                  await habitService.logCompletionForDate(
                    habitId: habit.id,
                    userId: widget.userId,
                    value: v,
                    date: widget.selectedDate,
                  );
                  await Future.delayed(const Duration(milliseconds: 120));
                } finally {
                  // Small extra buffer so the stream emission from the DB
                  // write also lands while the flag is still true
                  await Future.delayed(const Duration(milliseconds: 150));
                  _isActivelyLogging = false;
                }
              },
              onUndo: () async {
                _isActivelyLogging = true;
                try {
                  await habitService.deleteCompletionsForDay(
                    habitId: habit.id,
                    userId: widget.userId,
                    date: widget.selectedDate,
                  );
                  await Future.delayed(const Duration(milliseconds: 150));
                } finally {
                  _isActivelyLogging = false;
                }
              },
              selectedDate: widget.selectedDate,
              journalService: journalService,
            ),
          ),
      ],
    );
  }
}