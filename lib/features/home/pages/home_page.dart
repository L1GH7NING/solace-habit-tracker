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
  late DateTime _selectedDate;
  late DateTime _today;
  late List<DateTime> _datesList;

  // Banner State
  bool _showBanner = false;
  int? _lastStreakCount;
  Timer? _bannerTimer;
  StreamSubscription<PerfectStreakResult>? _streakSubscription;

  // Stream Memoization (Prevents rebuilding streams on every frame)
  Stream<List<Habit>>? _habitsStream;
  Stream<List<HabitCompletion>>? _dailyCompletionsStream;
  Stream<List<HabitCompletion>>? _weeklyCompletionsStream;
  DateTime? _memoizedDate;

  // Cached weekday map for O(1) lookups during filtering
  static const Map<int, String> _weekdayMap = {
    1: 'MON', 2: 'TUE', 3: 'WED', 4: 'THU', 5: 'FRI', 6: 'SAT', 7: 'SUN',
  };

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = _today;
    _datesList = List.generate(
      61,
      (index) => now.subtract(const Duration(days: 30)).add(Duration(days: index)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streakSubscription ??= StatsService(
      Provider.of<AppDatabase>(context, listen: false),
    ).watchPerfectStreak(_userId).listen(_handleStreakUpdate);
  }

  void _handleStreakUpdate(PerfectStreakResult result) {
    final current = result.currentStreak;

    if (_lastStreakCount != null) {
      if (current > _lastStreakCount!) {
        _triggerBanner();
      } else if (current < _lastStreakCount!) {
        _hideBanner();
      }
    }

    _lastStreakCount = current;
  }

  void _triggerBanner() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 300, amplitude: 120);
    }
    setState(() => _showBanner = true);
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showBanner = false);
    });
  }

  void _hideBanner() {
    _bannerTimer?.cancel();
    if (mounted && _showBanner) {
      setState(() => _showBanner = false);
    }
  }

  @override
  void dispose() {
    _streakSubscription?.cancel();
    _bannerTimer?.cancel();
    super.dispose();
  }

  DateTime _getStartOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  bool _applies(Habit h, DateTime d) {
    final habitStartDay = DateTime(h.startDate.year, h.startDate.month, h.startDate.day);
    final checkDay = DateTime(d.year, d.month, d.day);
    
    if (checkDay.isBefore(habitStartDay)) return false;
  
    if (h.frequencyDays == null || h.frequencyDays!.isEmpty) return true;
    return h.frequencyDays!.toUpperCase().contains(_weekdayMap[d.weekday]!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>();
    final appDb = Provider.of<AppDatabase>(context, listen: false);
    final habitService = HabitService(appDb);

    final bool canLog = !_selectedDate.isAfter(_today);
    final bool canJournal = !_selectedDate.isAfter(_today);

    // 1. Memoize Habits Stream (Only created once)
    _habitsStream ??= habitService.watchHabits(_userId);

    // 2. Memoize Completion Streams (Only update when the date actually changes)
    if (_memoizedDate != _selectedDate) {
      _dailyCompletionsStream = habitService.watchCompletionsForDate(_userId, _selectedDate);
      _weeklyCompletionsStream = habitService.watchCompletionsForDate(_userId, _getStartOfWeek(_selectedDate));
      _memoizedDate = _selectedDate;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // PERFORMANCE FIX: RepaintBoundary forces Flutter to render these expensive blurs 
          // into an offline image cache. Now, during page transitions, Flutter just moves 
          // the cached image instead of recalculating the blur on every frame.
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GreetingWidget(
                    name: userProvider.name,
                    avatar: userProvider.avatar,
                  ),
                  const SizedBox(height: 20),
                  DateStrip(
                    selectedDate: _selectedDate,
                    today: _today,
                    dates: _datesList,
                    onDateSelected: (d) => setState(() => _selectedDate = d),
                  ),
                  const SizedBox(height: 20),
                  
                  // Use the memoized streams safely
                  StreamBuilder<List<Habit>>(
                    stream: _habitsStream,
                    builder: (context, hSnap) {
                      final all = hSnap.data ?? [];
                      final daily = all.where((h) => h.frequencyType == 'DAILY' && _applies(h, _selectedDate)).toList();
                      final weekly = all.where((h) => h.frequencyType == 'WEEKLY' && _applies(h, _selectedDate)).toList();

                      if (daily.isEmpty && weekly.isEmpty) {
                        return EmptyState(
                          message: "No habits today",
                          theme: theme,
                        );
                      }

                      return StreamBuilder<List<HabitCompletion>>(
                        stream: _dailyCompletionsStream,
                        builder: (context, dComp) {
                          return StreamBuilder<List<HabitCompletion>>(
                            stream: _weeklyCompletionsStream,
                            builder: (context, wComp) {
                              return Column(
                                children: [
                                  if (daily.isNotEmpty)
                                    DailyHabitsSection(
                                      dailyHabits: daily,
                                      dailyCompletions: dComp.data ?? [],
                                      userId: _userId,
                                      selectedDate: _selectedDate,
                                      isToday: _selectedDate == _today,
                                      canLog: canLog,
                                      canJournal: canJournal,
                                    ),
                                  if (weekly.isNotEmpty) ...[
                                    const SizedBox(height: 28),
                                    WeeklyHabitsSection(
                                      weeklyHabits: weekly,
                                      weeklyCompletions: wComp.data ?? [],
                                      userId: _userId,
                                      weekStartDate: _getStartOfWeek(_selectedDate),
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),

          TopCelebrationBanner(
            visible: _showBanner,
            title: "Great Job!",
            message: "You completed all habits for today",
            animationSeed: _lastStreakCount ?? 0,
          ),
        ],
      ),
    );
  }
}