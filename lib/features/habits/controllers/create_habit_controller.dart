import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart'; // ⚠️ adjust path
import 'package:drift/drift.dart' show Value;
import 'package:zenith_habit_tracker/features/habits/controllers/habit_controller_base.dart';

class CreateHabitController implements HabitControllerBase {
  final BuildContext context;
  final AppDatabase db;

  // ── Form state (owned by the controller, exposed to the view) ─────────────
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedIcon = '⭐';
  String frequencyType = 'DAILY'; // 'DAILY' | 'WEEKLY' | 'MONTHLY'
  List<String> frequencyDays = []; // e.g. ['MON', 'WED', 'FRI']
  int targetCount = 1;
  int selectedColor = 0xFF5D5FEF; // ARGB int — matches AppColors.primary
  DateTime startDate = DateTime.now();

  CreateHabitController({required this.context, required this.db});

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> saveHabit({int? habitTime, int? reminderTime}) async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a habit name.');
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    await db.insertHabit(
      HabitsCompanion.insert(
        userId: userId,
        title: title,
        description: Value(
          descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        ),
        icon: selectedIcon,
        color: selectedColor,
        frequencyType: Value(frequencyType),
        frequencyDays: Value(
          frequencyDays.isEmpty ? null : frequencyDays.join(','),
        ),
        targetCount: Value(targetCount),
        startDate: startDate,
        updatedAt: DateTime.now(),
        habitTime: Value(habitTime),
        reminderTime: Value(reminderTime),
        // isSynced defaults to false — picked up by sync queue later
      ),
    );

    if (context.mounted) {
      _showSuccess('Habit created!');
      // Small delay so the snackbar is visible before pop
      await Future.delayed(const Duration(milliseconds: 600));
      if (context.mounted) context.pop();
    }
  }

  // ── Target count ──────────────────────────────────────────────────────────

  void incrementTarget() {
    if (targetCount < 99) targetCount++;
  }

  void decrementTarget() {
    if (targetCount > 1) targetCount--;
  }

  // ── Frequency ─────────────────────────────────────────────────────────────

  void setFrequency(String type) {
    frequencyType = type;
    // Reset custom days when switching away from custom
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
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
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
