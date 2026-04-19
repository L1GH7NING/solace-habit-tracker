import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:zenith_habit_tracker/features/common/widgets/dialog_box.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/habit_controller_base.dart';

class EditHabitController implements HabitControllerBase {
  final BuildContext context;
  final AppDatabase db;
  final Habit habit;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  late String selectedIcon;
  late String frequencyType;
  late List<String> frequencyDays;

  // ✅ CACHE: Stores the specific days so they aren't lost when toggling to Weekly
  late List<String> _cachedDailyDays;

  // ✅ New schema — double value + string unit
  late double targetValue;
  late String unit;

  @override
  late int selectedColor;

  EditHabitController({
    required this.context,
    required this.db,
    required this.habit,
  }) {
    titleController = TextEditingController(text: habit.title);
    descriptionController = TextEditingController(
      text: habit.description ?? '',
    );
    selectedIcon = habit.icon;
    frequencyType = habit.frequencyType;

    // Load existing days
    frequencyDays = habit.frequencyDays != null
        ? habit.frequencyDays!.split(',').where((s) => s.isNotEmpty).toList()
        : [];

    if (frequencyDays.isNotEmpty) {
      _cachedDailyDays = List.from(frequencyDays);
    } else {
      _cachedDailyDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    }

    targetValue = habit.targetValue;
    unit = habit.unit;
    selectedColor = habit.color;
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }

  String get _habitType {
    switch (unit) {
      case 'times':
        return 'count';
      case 'minutes':
      case 'hours':
        return 'duration';
      default:
        return 'quantity';
    }
  }

  int get targetCount => targetValue.toInt();

  void incrementTarget() {
    if (targetValue < 99) targetValue++;
  }

  void decrementTarget() {
    if (targetValue > 1) targetValue--;
  }

  // ── Frequency ─────────────────────────────────────────────────────────────
  void setFrequency(String type) {
    // ✅ If we are moving AWAY from DAILY, save the current specific days to memory
    if (frequencyType == 'DAILY' && type != 'DAILY') {
      _cachedDailyDays = List.from(frequencyDays);
    }

    frequencyType = type;

    if (type == 'DAILY') {
      // ✅ Restore the cached days when returning to DAILY
      frequencyDays = List.from(_cachedDailyDays);
    } else {
      // ✅ Clear the active days for Weekly so we don't accidentally save them to DB
      frequencyDays = [];
    }
  }

  void toggleFrequencyDay(String day) {
    if (frequencyDays.contains(day)) {
      frequencyDays.remove(day);
    } else {
      frequencyDays.add(day);
    }
    // Keep cache completely in sync as they tap
    _cachedDailyDays = List.from(frequencyDays);
  }

  // ── Save (update) ─────────────────────────────────────────────────────────
  Future<bool> saveHabit({int? habitTime, int? reminderTime}) async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a habit name.');
      return false;
    }

    if (targetValue <= 0) {
      _showError('Goal must be greater than zero.');
      return false;
    }

    final hasChanged =
        title != habit.title ||
        (descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim()) !=
            habit.description ||
        selectedIcon != habit.icon ||
        selectedColor != habit.color ||
        frequencyType != habit.frequencyType ||
        (frequencyDays.isEmpty ? null : frequencyDays.join(',')) !=
            habit.frequencyDays ||
        targetValue != habit.targetValue ||
        unit != habit.unit ||
        habitTime != habit.habitTime ||
        reminderTime != habit.reminderTime;

    if (!hasChanged) {
      _showError('No changes made.');
      return false;
    }

    try {
      await db.updateHabit(
        HabitsCompanion(
          id: Value(habit.id),
          userId: Value(habit.userId),
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
          targetValue: Value(targetValue),
          unit: Value(unit),
          type: Value(_habitType),
          habitTime: Value(habitTime),
          reminderTime: Value(reminderTime),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
          pendingOperation: const Value('UPDATE'),
        ),
      );

      if (context.mounted) {
        showAppSnackBar(
          context,
          'Habit updated successfully!',
          type: SnackBarType.success,
        );
      }
      return true;
    } catch (e) {
      _showError('Failed to update habit.');
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<void> deleteHabit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DialogBox(
        title: 'Delete Habit',
        confirmText: 'Delete',
        isDestructive: true,
        content: const Text(
          'Are you sure you want to delete this habit? This action cannot be undone.',
        ),
        onConfirm: () async {
          await db.archiveHabit(habit.id);
        },
      ),
    );

    if (confirmed == true && context.mounted) {
      showAppSnackBar(
        context,
        'Habit Deleted',
        type: SnackBarType.warning,
      );
      context.go("/home");
    }
  }

  // ── Error snackbar ────────────────────────────────────────────────────────
  void _showError(String message) {
    showAppSnackBar(context, message, type: SnackBarType.error);
  }
}
