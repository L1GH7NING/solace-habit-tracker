import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class HabitCardContent extends StatelessWidget {
  final Habit habit;
  final double progress;
  final double currentProgress;
  final double target;
  final bool isDone;
  final Color habitColor;
  final VoidCallback onTap;
  final Widget actionButton;

  const HabitCardContent({
    super.key,
    required this.habit,
    required this.progress,
    required this.currentProgress,
    required this.target,
    required this.isDone,
    required this.habitColor,
    required this.onTap,
    required this.actionButton,
  });

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progressText = currentProgress.toStringAsFixed(
      currentProgress.truncateToDouble() == currentProgress ? 0 : 1,
    );

    final targetText = target.toStringAsFixed(
      target.truncateToDouble() == target ? 0 : 1,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border(left: BorderSide(color: habitColor, width: 4)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: habitColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                getIconFromId(habit.icon),
                size: 32,
                color: habitColor,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (habit.habitTime != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      Utilities.formatMinutes(habit.habitTime!, context),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),

                  if (isDone)
                    Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              valueColor:
                                  AlwaysStoppedAnimation(habitColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$progressText / $targetText ${habit.unit}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            actionButton,
          ],
        ),
      ),
    );
  }
}