import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';

void showJournalBottomSheet(
  BuildContext context,
  Habit habit,
  Color color,
) {
  HapticFeedback.lightImpact();
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => JournalBottomSheet(habit: habit, color: color),
  );
}

class JournalBottomSheet extends StatelessWidget {
  final Habit habit;
  final Color color;

  const JournalBottomSheet({
    super.key,
    required this.habit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bookOpen, color: color),
              const SizedBox(width: 12),
              Text(
                'Journal',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Habit: ${habit.title}',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const Expanded(
            child: Center(
              child: Text('Dummy Journal content goes here.'),
            ),
          ),
        ],
      ),
    );
  }
}