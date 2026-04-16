import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';
import 'package:zenith_habit_tracker/features/home/widgets/habit_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/perfect_streak_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/progress_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/section_header.dart';
import 'package:intl/intl.dart';

class DailyHabitsSection extends StatelessWidget {
  final List<Habit> dailyHabits;
  final List<HabitCompletion> dailyCompletions;
  final String userId;
  final DateTime selectedDate;
  final bool isToday;
  final bool canLog; // Parameter explicitly added here
  final bool canJournal;

  const DailyHabitsSection({
    super.key,
    required this.dailyHabits,
    required this.dailyCompletions,
    required this.userId,
    required this.selectedDate,
    required this.isToday,
    this.canLog = true, // Default to true so it doesn't break instances
    this.canJournal = true,
  });

  double _progressFor(Habit habit) => dailyCompletions
      .where((c) => c.habitId == habit.id)
      .fold<double>(0.0, (sum, c) => sum + c.value);

  @override
  Widget build(BuildContext context) {
    final habitService = HabitService(
      Provider.of<AppDatabase>(context, listen: false),
    );

    // ─── SORTING LOGIC ───
    final sortedHabits = List<Habit>.from(dailyHabits)
      ..sort((a, b) {
        final timeA = a.habitTime;
        final timeB = b.habitTime;

        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;

        return timeA.compareTo(timeB);
      });

    final completedCount = dailyHabits
        .where((h) => _progressFor(h) >= h.targetValue)
        .length;
    final formattedDate = DateFormat('MMMM d').format(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ProgressCard(
                completed: completedCount,
                total: dailyHabits.length,
                isToday: isToday,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<PerfectStreakResult>(
                stream: StatsService(
                  Provider.of<AppDatabase>(context, listen: false),
                ).watchPerfectStreak(userId),
                builder: (context, streakSnap) =>
                    PerfectStreakCard(result: streakSnap.data),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionHeader(
          title: isToday ? "Today's Habits" : "Habits for $formattedDate",
        ),
        const SizedBox(height: 12),
        // ─── RENDERING SORTED LIST ───
        ...sortedHabits.map(
          (habit) => HabitCard(
            key: ValueKey('daily_${habit.id}_$selectedDate'),
            habit: habit,
            currentProgress: _progressFor(habit),
            canLog: canLog, // Passed parameter explicitly
            canJournal: canJournal,
            onTap: () => context.push('/edit-habit', extra: habit),
            onLog: (v) => habitService.logCompletionForDate(
              habitId: habit.id,
              userId: userId,
              value: v,
              date: selectedDate,
            ),
            onUndo: () => habitService.deleteCompletionsForDay(
              habitId: habit.id,
              userId: userId,
              date: selectedDate,
            ),
          ),
        ),
      ],
    );
  }
}