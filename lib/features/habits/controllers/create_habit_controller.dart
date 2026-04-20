import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart'; // ⚠️ adjust path
import 'package:drift/drift.dart' show Value;
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/habit_controller_base.dart';
import 'dart:math';

import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';

class CreateHabitController implements HabitControllerBase {
  final BuildContext context;
  final AppDatabase db;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final logger = Logger();
  final _random = Random();

  @override
  String selectedIcon = 'run';

  @override
  int selectedColor = 0xFF5D5FEF;

  String frequencyType = 'DAILY';
  List<String> frequencyDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  // ✅ New schema fields
  double targetValue = 1;
  String unit = 'times';

  DateTime startDate = DateTime.now();

  CreateHabitController({required this.context, required this.db}) {
    _assignRandomDefaults();
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }

  void _assignRandomDefaults() {
    final randomIcon = iconOptions[_random.nextInt(iconOptions.length)];
    final randomColor = colorOptions[_random.nextInt(colorOptions.length)];

    selectedIcon = randomIcon.id;
    selectedColor = randomColor.value;
  }

  // ── Infer habit type from unit ─────────────────────────────────────────────
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

  // ── Stepper helpers (used when unit == "times") ───────────────────────────
  int get targetCount => targetValue.toInt();

  void incrementTarget() {
    if (targetValue < 99) targetValue++;
  }

  void decrementTarget() {
    if (targetValue > 1) targetValue--;
  }

  // ── Frequency ─────────────────────────────────────────────────────────────
  void setFrequency(String type) {
    frequencyType = type;
    if (type != 'WEEKLY') {
      frequencyDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    }
  }

  void toggleFrequencyDay(String day) {
    if (frequencyDays.contains(day)) {
      frequencyDays.remove(day);
    } else {
      frequencyDays.add(day);
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────
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

    if (frequencyType == 'DAILY' && frequencyDays.isEmpty) {
      _showError('Please select atleast one day for a daily habit');
      return false;
    }

    try {
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
          targetValue: Value(targetValue),
          unit: Value(unit),
          type: Value(_habitType),
          startDate: startDate,
          updatedAt: DateTime.now(),
          habitTime: Value(habitTime),
          reminderTime: Value(reminderTime),
        ),
      );

      if (context.mounted) context.go('/home');
      return true;
    } catch (e) {
      logger.e('❌ Error creating habit: $e');
      _showError('Failed to create habit: ${e.toString()}');
      return false;
    }
  }

  void _showError(String message) {
    showAppSnackBar(context, message, type: SnackBarType.error);
  }
}
