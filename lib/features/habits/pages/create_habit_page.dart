// lib/features/habits/pages/create_habit_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/create_habit_controller.dart';
import 'package:zenith_habit_tracker/features/habits/views/create_habit_view.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/appearance_bottom_sheet.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_preset_bottom_sheet.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class CreateHabitPageStateAccess {
  final CreateHabitController controller;
  final Color accentColor;
  final IconData currentIconData;
  final TimeOfDay selectedTime;
  final bool hasTime;
  final bool reminderEnabled;
  final int selectedReminderOffset;
  final List<int> reminderOptions;
  final VoidCallback rebuild;
  final VoidCallback handleSave;
  final Function(bool) setHasTime;
  final Function(TimeOfDay) setSelectedTime;
  final Function(bool) setReminderEnabled;
  final Function(int) setSelectedReminderOffset;
  final Function() showAppearancePicker;
  final Function() showPresetPicker;

  CreateHabitPageStateAccess({
    required this.controller,
    required this.accentColor,
    required this.currentIconData,
    required this.selectedTime,
    required this.hasTime,
    required this.reminderEnabled,
    required this.selectedReminderOffset,
    required this.reminderOptions,
    required this.rebuild,
    required this.handleSave,
    required this.setHasTime,
    required this.setSelectedTime,
    required this.setReminderEnabled,
    required this.setSelectedReminderOffset,
    required this.showAppearancePicker,
    required this.showPresetPicker,
  });
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  late final CreateHabitController _controller;

  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  bool _hasTime = false;
  bool _reminderEnabled = false;
  int _selectedReminderOffset = 15;
  static const List<int> _reminderOptions = [
    5,
    10,
    15,
    30,
    60,
  ]; // PERFORMANCE: Made this static const

  @override
  void initState() {
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);
    _controller = CreateHabitController(context: context, db: db);
    _controller.titleController.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.titleController.removeListener(_rebuild);
    _controller.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _showAppearancePicker() {
    showAppearancePicker(context, controller: _controller, onUpdate: _rebuild);
  }

  void _showPresetPicker() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HabitPresetBottomSheet(onPresetSelected: _applyPreset),
    );
  }

  void _applyPreset(HabitPreset preset) {
    _controller.titleController.text = preset.title;
    _controller.descriptionController.text = preset.description;
    _controller.selectedColor = preset.colorValue;
    _controller.selectedIcon = preset.iconId;
    _controller.setFrequency(preset.frequencyType);
    _controller.targetValue = preset.targetValue;
    _controller.unit = preset.unit;

    _rebuild();
  }

  void _handleSave() async {
    int? habitMinutes = _hasTime
        ? Utilities.timeToMinutes(_selectedTime)
        : null;

    int? reminderMinutes;
    if (_hasTime && _reminderEnabled && habitMinutes != null) {
      reminderMinutes = (habitMinutes - _selectedReminderOffset).clamp(0, 1440);
    }

    final success = await _controller.saveHabit(
      habitTime: habitMinutes,
      reminderTime: reminderMinutes,
    );

    if (!mounted) return;

    if (success) {
      showAppSnackBar(
        context,
        'Habit created successfully!',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate these once per build instead of via getters
    final currentIconData = iconOptions
        .firstWhere(
          (opt) => opt.id == _controller.selectedIcon,
          orElse: () => iconOptions.first,
        )
        .icon;

    final accentColor = AdaptiveColors.accent(
      context,
      Color(_controller.selectedColor),
    );

    final access = CreateHabitPageStateAccess(
      controller: _controller,
      accentColor: accentColor,
      currentIconData: currentIconData,
      selectedTime: _selectedTime,
      hasTime: _hasTime,
      reminderEnabled: _reminderEnabled,
      selectedReminderOffset: _selectedReminderOffset,
      reminderOptions: _reminderOptions,
      rebuild: _rebuild,
      handleSave: _handleSave,
      showAppearancePicker: _showAppearancePicker,
      showPresetPicker: _showPresetPicker,
      setHasTime: (val) => setState(() => _hasTime = val),
      setSelectedTime: (val) => setState(() => _selectedTime = val),
      setReminderEnabled: (val) => setState(() => _reminderEnabled = val),
      setSelectedReminderOffset: (val) =>
          setState(() => _selectedReminderOffset = val),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'New Habit',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          // 🔥 PERFORMANCE FIX: RepaintBoundary isolates the heavy blurs!
          RepaintBoundary(
            child: Stack(
              children: [
                Positioned(
                  top: 120,
                  left: -80,
                  child: BlurCircle(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    size: 260,
                  ),
                ),
                Positioned(
                  bottom: 120,
                  right: -80,
                  child: BlurCircle(
                    color: theme.colorScheme.secondary.withOpacity(0.12),
                    size: 300,
                  ),
                ),
              ],
            ),
          ),

          SafeArea(bottom: false, child: CreateHabitView(access: access)),
        ],
      ),
    );
  }
}
