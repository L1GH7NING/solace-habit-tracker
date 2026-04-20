// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart'; // Add this import
import 'package:zenith_habit_tracker/features/home/widgets/daily_habits_section.dart';
import 'package:zenith_habit_tracker/features/home/widgets/date_strip.dart';
import 'package:zenith_habit_tracker/features/home/widgets/empty_state.dart';
import 'package:zenith_habit_tracker/features/home/widgets/greeting_widget.dart';
import 'package:zenith_habit_tracker/features/home/widgets/weekly_habits_section.dart';
import 'package:zenith_habit_tracker/features/home/widgets/top_celebration_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String _userId;
  late DateTime _today;
  late List<DateTime> _datesList;

  // State via ValueNotifier to prevent full page rebuilds
  late final ValueNotifier<DateTime> _selectedDateNotifier;

  // Banner State
  bool _showBanner = false;
  int? _lastStreakCount;
  Timer? _bannerTimer;
  StreamSubscription<PerfectStreakResult>? _streakSubscription;

  // Cached Services
  late final HabitService _habitService;
  late final JournalService _journalService;
  late final StatsService _statsService;

  // Base Streams
  Stream<List<Habit>>? _habitsStream;
  Stream<List<HabitTargetHistoryData>>? _historyStream;

  static const Map<int, String> _weekdayMap = {
    1: 'MON',
    2: 'TUE',
    3: 'WED',
    4: 'THU',
    5: 'FRI',
    6: 'SAT',
    7: 'SUN',
  };

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDateNotifier = ValueNotifier<DateTime>(_today);

    _datesList = List.generate(
      61,
      (index) =>
          now.subtract(const Duration(days: 30)).add(Duration(days: index)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_habitsStream == null) {
      final appDb = context.read<AppDatabase>();
      _habitService = HabitService(appDb);
      _journalService = JournalService(appDb);
      _statsService = StatsService(appDb);

      _habitsStream = _habitService.watchHabits(_userId);
      _historyStream = appDb.watchTargetHistoryForUser(_userId);
    }

    _streakSubscription ??= _statsService
        .watchPerfectStreak(_userId)
        .listen(_handleStreakUpdate);
  }

  void _handleStreakUpdate(PerfectStreakResult result) {
    final current = result.currentStreak;
    if (_lastStreakCount != null) {
      if (current > _lastStreakCount!)
        _triggerBanner();
      else if (current < _lastStreakCount!)
        _hideBanner();
    }
    _lastStreakCount = current;
  }

  void _triggerBanner() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) Vibration.vibrate(duration: 300, amplitude: 120);

    setState(() => _showBanner = true);
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showBanner = false);
    });
  }

  void _hideBanner() {
    _bannerTimer?.cancel();
    if (mounted && _showBanner) setState(() => _showBanner = false);
  }

  @override
  void dispose() {
    _streakSubscription?.cancel();
    _bannerTimer?.cancel();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  DateTime _getStartOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  bool _applies(Habit h, DateTime d) {
    final habitStartDay = DateTime(
      h.startDate.year,
      h.startDate.month,
      h.startDate.day,
    );
    final checkDay = DateTime(d.year, d.month, d.day);
    if (checkDay.isBefore(habitStartDay)) return false;
    if (h.frequencyDays?.isEmpty ?? true) return true;
    return h.frequencyDays!.toUpperCase().contains(_weekdayMap[d.weekday]!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Performant state tracking: Only rebuilds HomePage if name/avatar changes
    final userName = context.select<UserProvider, String>((p) => p.name);
    final avatar = context.select<UserProvider, String?>((p) => p.avatar);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background UI
          RepaintBoundary(
            child: Stack(
              children: [
                Positioned(
                  top: -60,
                  left: -80,
                  child: BlurCircle(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    size: 300,
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: -100,
                  child: BlurCircle(
                    color: theme.colorScheme.secondary.withOpacity(0.15),
                    size: 320,
                  ),
                ),
              ],
            ),
          ),

          // Foreground UI
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: _selectedDateNotifier,
                builder: (context, selectedDate, _) {
                  final bool canLog = !selectedDate.isAfter(_today);

                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      GreetingWidget(name: userName, avatar: avatar),
                      const SizedBox(height: 20),
                      DateStrip(
                        selectedDate: selectedDate,
                        today: _today,
                        dates: _datesList,
                        onDateSelected: (d) => _selectedDateNotifier.value = d,
                      ),
                      const SizedBox(height: 20),

                      _buildHabitsSection(selectedDate, canLog, theme),
                      const SizedBox(height: 140),
                    ],
                  );
                },
              ),
            ),
          ),
          TopCelebrationBanner(
            visible: _showBanner,
            title: "Nice work, $userName!",
            message: "All habits completed today",
          ),
        ],
      ),
    );
  }

  // Isolated widget building to keep the build method clean
  Widget _buildHabitsSection(
    DateTime selectedDate,
    bool canLog,
    ThemeData theme,
  ) {
    final startOfWeek = _getStartOfWeek(selectedDate);

    return StreamBuilder<List<HabitTargetHistoryData>>(
      stream: _historyStream,
      builder: (context, historySnap) {
        final history = historySnap.data ?? [];

        return StreamBuilder<List<Habit>>(
          stream: _habitsStream,
          builder: (context, hSnap) {
            final all = hSnap.data ?? [];
            final daily = all
                .where(
                  (h) =>
                      h.frequencyType == 'DAILY' && _applies(h, selectedDate),
                )
                .toList();
            final weekly = all
                .where(
                  (h) =>
                      h.frequencyType == 'WEEKLY' && _applies(h, selectedDate),
                )
                .toList();

            if (daily.isEmpty && weekly.isEmpty) {
              return EmptyState(
                message: "No habits today",
                theme: theme,
                showCTA: selectedDate == _today,
              );
            }

            return StreamBuilder<List<HabitCompletion>>(
              stream: _habitService.watchCompletionsForDate(
                _userId,
                selectedDate,
              ),
              builder: (context, dComp) {
                return StreamBuilder<List<HabitCompletion>>(
                  stream: _habitService.watchCompletionsForDate(
                    _userId,
                    startOfWeek,
                  ),
                  builder: (context, wComp) {
                    return Column(
                      children: [
                        if (daily.isNotEmpty)
                          DailyHabitsSection(
                            dailyHabits: daily,
                            dailyCompletions: dComp.data ?? [],
                            userId: _userId,
                            selectedDate: selectedDate,
                            isToday: selectedDate == _today,
                            canLog: canLog,
                            canJournal: canLog,
                            targetHistory: history,
                            habitService: _habitService, // Passed down
                            journalService: _journalService, // Passed down
                            statsService: _statsService, // Passed down
                          ),
                        if (weekly.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          WeeklyHabitsSection(
                            weeklyHabits: weekly,
                            weeklyCompletions: wComp.data ?? [],
                            userId: _userId,
                            weekStartDate: startOfWeek,
                            targetHistory: history,
                            habitService: _habitService, // Passed down
                            journalService: _journalService, // Passed down
                            statsService: _statsService, // Passed down
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
