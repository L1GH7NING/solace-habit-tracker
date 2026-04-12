import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/models/habit_model_ui.dart';

class HabitCard extends StatelessWidget {
  final HabitUIModel habit;
  final VoidCallback onTap;
  final VoidCallback onIncrement;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onIncrement,
  });

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = habit.current >= habit.target;
    final progress = habit.target > 0 ? habit.current / habit.target : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border(left: BorderSide(color: habit.color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                getIconFromId(habit.icon),
                size: 32,
                color: habit.color,
              ),
            ),
            const SizedBox(width: 14),
      
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
      
                  if (habit.time.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      habit.time,
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
                        letterSpacing: 0.5,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 4,
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                habit.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${habit.current}/${habit.target}',
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
      
            // Button
            GestureDetector(
              onTap: isDone ? null : onIncrement,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone
                      ? theme.colorScheme.secondaryContainer
                      : habit.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : Icons.add_rounded,
                  color: isDone ? theme.colorScheme.primary : Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
