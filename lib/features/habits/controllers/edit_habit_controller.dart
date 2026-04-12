import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:zenith_habit_tracker/features/habits/controllers/habit_controller_base.dart';

class EditHabitController implements HabitControllerBase {
  final BuildContext context;
  final AppDatabase db;
  final Habit habit; // the existing habit being edited

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  late String selectedIcon;
  late String frequencyType;
  late List<String> frequencyDays;
  late int targetCount;
  @override
  late int selectedColor;

  EditHabitController({
    required this.context,
    required this.db,
    required this.habit,
  }) {
    // Pre-populate all fields from the existing habit
    titleController = TextEditingController(text: habit.title);
    descriptionController = TextEditingController(
      text: habit.description ?? '',
    );
    selectedIcon = habit.icon;
    frequencyType = habit.frequencyType;
    frequencyDays = habit.frequencyDays != null
        ? habit.frequencyDays!.split(',').where((s) => s.isNotEmpty).toList()
        : [];
    targetCount = habit.targetCount;
    selectedColor = habit.color;
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }

  // ── Save (update) ─────────────────────────────────────────────────────────

  Future<void> saveHabit({int? habitTime, int? reminderTime}) async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a habit name.');
      return;
    }

    await db.updateHabit(
      HabitsCompanion(
        userId: Value(habit.userId),
        id: Value(habit.id),
        title: Value(title),
        description: Value(
          descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        ),
        startDate: Value(habit.startDate),
        icon: Value(selectedIcon),
        color: Value(selectedColor),
        frequencyType: Value(frequencyType),
        frequencyDays: Value(
          frequencyDays.isEmpty ? null : frequencyDays.join(','),
        ),
        targetCount: Value(targetCount),
        habitTime: Value(habitTime),
        reminderTime: Value(reminderTime),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
        pendingOperation: const Value('UPDATE'),
      ),
    );

    if (context.mounted) context.pop();
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteHabit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Habit',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to delete "${habit.title}"? This cannot be undone.',
          style: TextStyle(color: Theme.of(ctx).colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await db.archiveHabit(habit.id);
      if (context.mounted) context.pop();
    }
  }

  // ── Increment / Decrement ─────────────────────────────────────────────────

  void incrementTarget() {
    if (targetCount < 99) targetCount++;
  }

  void decrementTarget() {
    if (targetCount > 1) targetCount--;
  }

  void setFrequency(String type) {
    frequencyType = type;
    if (type != 'WEEKLY') frequencyDays = [];
  }

  void toggleFrequencyDay(String day) {
    if (frequencyDays.contains(day)) {
      frequencyDays.remove(day);
    } else {
      frequencyDays.add(day);
    }
  }

  // ── Snackbars ─────────────────────────────────────────────────────────────

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
