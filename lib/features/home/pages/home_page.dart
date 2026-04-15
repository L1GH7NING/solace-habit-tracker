// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';
import 'package:zenith_habit_tracker/features/home/widgets/daily_habits_section.dart';
import 'package:zenith_habit_tracker/features/home/widgets/date_strip.dart';
import 'package:zenith_habit_tracker/features/home/widgets/empty_state.dart';
import 'package:zenith_habit_tracker/features/home/widgets/greeting_widget.dart';
import 'package:zenith_habit_tracker/features/home/widgets/weekly_habits_section.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String _userId;
  late DateTime _selectedDate;
  late DateTime _today;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _selectedDate = _today;
    _weekDays = List.generate(7, (i) => _today.subtract(Duration(days: 6 - i)));
  }

  DateTime _getStartOfWeek(DateTime date) => date.subtract(Duration(days: date.weekday - 1));

  bool _applies(Habit h, DateTime d) {
    if (h.frequencyDays == null || h.frequencyDays!.isEmpty) return true;
    final map = {1:'MON', 2:'TUE', 3:'WED', 4:'THU', 5:'FRI', 6:'SAT', 7:'SUN'};
    return h.frequencyDays!.toUpperCase().contains(map[d.weekday]!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>();
    final habitService = HabitService(Provider.of<AppDatabase>(context, listen: false));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(top: -60, left: -80, child: BlurCircle(color: theme.colorScheme.primary.withOpacity(0.12), size: 300)),
          Positioned(bottom: 80, right: -100, child: BlurCircle(color: theme.colorScheme.secondary.withOpacity(0.15), size: 320)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GreetingWidget(name: userProvider.name, avatar: userProvider.avatar),
                  const SizedBox(height: 20),
                  DateStrip(
                    selectedDate: _selectedDate,
                    today: _today,
                    weekDays: _weekDays,
                    onDateSelected: (d) => setState(() => _selectedDate = d),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<List<Habit>>(
                    stream: habitService.watchHabits(_userId),
                    builder: (context, hSnap) {
                      final all = hSnap.data ?? [];
                      final daily = all.where((h) => h.frequencyType == 'DAILY' && _applies(h, _selectedDate)).toList();
                      final weekly = all.where((h) => h.frequencyType == 'WEEKLY' && _applies(h, _selectedDate)).toList();

                      if (daily.isEmpty && weekly.isEmpty) {
                        return EmptyState(message: "No habits today", theme: theme);
                      }

                      return StreamBuilder<List<HabitCompletion>>(
                        stream: habitService.watchCompletionsForDate(_userId, _selectedDate),
                        builder: (context, dComp) {
                          return StreamBuilder<List<HabitCompletion>>(
                            stream: habitService.watchCompletionsForDate(_userId, _getStartOfWeek(_selectedDate)),
                            builder: (context, wComp) {
                              return Column(
                                children: [
                                  if (daily.isNotEmpty) DailyHabitsSection(dailyHabits: daily, dailyCompletions: dComp.data ?? [], userId: _userId, selectedDate: _selectedDate, isToday: _selectedDate == _today),
                                  if (weekly.isNotEmpty) ...[
                                    const SizedBox(height: 28),
                                    WeeklyHabitsSection(weeklyHabits: weekly, weeklyCompletions: wComp.data ?? [], userId: _userId, weekStartDate: _getStartOfWeek(_selectedDate)),
                                  ]
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
        ],
      ),
    );
  }
}