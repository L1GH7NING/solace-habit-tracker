import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';
import 'package:zenith_habit_tracker/features/home/widgets/habit_card.dart';
import 'package:zenith_habit_tracker/features/home/widgets/section_header.dart';

class WeeklyHabitsSection extends StatelessWidget {
  final List<Habit> weeklyHabits;
  final List<HabitCompletion> weeklyCompletions;
  final String userId;
  final DateTime weekStartDate;

  const WeeklyHabitsSection({
    super.key,
    required this.weeklyHabits,
    required this.weeklyCompletions,
    required this.userId,
    required this.weekStartDate,
  });

  double _progressFor(Habit habit) => weeklyCompletions
      .where((c) => c.habitId == habit.id)
      .fold<double>(0.0, (sum, c) => sum + c.value);

  @override
  Widget build(BuildContext context) {
    final habitService = HabitService(
      Provider.of<AppDatabase>(context, listen: false),
    );

    // Check if all weekly habits in this list are finished
    final allDone =
        weeklyHabits.isNotEmpty &&
        weeklyHabits.every((h) => _progressFor(h) >= h.targetValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "This Week's Habits"),
        const SizedBox(height: 12),
        ...weeklyHabits.map(
          (habit) => HabitCard(
            key: ValueKey('weekly_${habit.id}_$weekStartDate'),
            habit: habit,
            currentProgress: _progressFor(habit),
            onTap: () => context.push('/edit-habit', extra: habit),
            onLog: (v) => habitService.logCompletionForDate(
              habitId: habit.id,
              userId: userId,
              value: v,
              date: weekStartDate,
            ),
            onUndo: () => habitService.deleteCompletionsForDay(
              habitId: habit.id,
              userId: userId,
              date: weekStartDate,
            ),
          ),
        ),
        if (allDone) const AllWeeklyCompletedMessage(),
      ],
    );
  }
}

class AllWeeklyCompletedMessage extends StatelessWidget {
  const AllWeeklyCompletedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_rounded, // trophy vibe > check icon
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "All habits completed this week",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
