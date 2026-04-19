import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/home/widgets/log_habit_sheet.dart';

void handleLog({
  required BuildContext context,
  required Habit habit,
  required Function(double value) onLog,
}) {
  if (habit.unit.toLowerCase() == 'times') {
    onLog(1.0);
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Required for keyboard
    // Use actual surface color instead of transparent to fix the "black void"
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => LogHabitSheet(habit: habit, onLog: onLog),
  );
}
