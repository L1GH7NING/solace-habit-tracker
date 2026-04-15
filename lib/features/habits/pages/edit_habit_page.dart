// lib/features/habits/views/edit_habit_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/edit_habit_controller.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/edit_habit_bottom_nav.dart';
import 'package:zenith_habit_tracker/features/habits/views/edit_habit_view.dart';
import 'package:zenith_habit_tracker/features/habits/views/habits_stats_view.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/appearance_bottom_sheet.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({super.key, required this.habit});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class EditHabitPageStateAccess {
  final EditHabitController controller;
  final Habit habit;
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

  EditHabitPageStateAccess({
    required this.controller,
    required this.habit,
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
  });
}

class _EditHabitPageState extends State<EditHabitPage> {
  late final EditHabitController _controller;

  // ADDED: PageController to manage the swiping
  late final PageController _pageController;
  int _selectedIndex = 0; // Default to stats view

  late TimeOfDay _selectedTime;
  late bool _hasTime;
  bool _reminderEnabled = false;
  int _selectedReminderOffset = 15;
  final List<int> _reminderOptions = [5, 10, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);
    _controller = EditHabitController(
      context: context,
      db: db,
      habit: widget.habit,
    );

    // ADDED: Initialize the PageController with the starting index
    _pageController = PageController(initialPage: _selectedIndex);

    if (widget.habit.habitTime != null) {
      _hasTime = true;
      _selectedTime = Utilities.minutesToTimeOfDay(widget.habit.habitTime!);
    } else {
      _hasTime = false;
      _selectedTime = const TimeOfDay(hour: 8, minute: 30);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // ADDED: Dispose the PageController to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});
  Color get _accent =>
      AdaptiveColors.accent(context, Color(_controller.selectedColor));

  IconData get _currentIconData {
    return iconOptions
        .firstWhere(
          (opt) => opt.id == _controller.selectedIcon,
          orElse: () => iconOptions.first,
        )
        .icon;
  }

  void _showAppearancePicker() {
    showAppearancePicker(context, controller: _controller, onUpdate: _rebuild);
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
        'Habit updated successfully!',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Create an access object to pass state and methods to child views
    final access = EditHabitPageStateAccess(
      controller: _controller,
      habit: widget.habit,
      accentColor: _accent,
      currentIconData: _currentIconData,
      selectedTime: _selectedTime,
      hasTime: _hasTime,
      reminderEnabled: _reminderEnabled,
      selectedReminderOffset: _selectedReminderOffset,
      reminderOptions: _reminderOptions,
      rebuild: _rebuild,
      handleSave: _handleSave,
      showAppearancePicker: _showAppearancePicker,
      setHasTime: (val) => setState(() => _hasTime = val),
      setSelectedTime: (val) => setState(() => _selectedTime = val),
      setReminderEnabled: (val) => setState(() => _reminderEnabled = val),
      setSelectedReminderOffset: (val) =>
          setState(() => _selectedReminderOffset = val),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          _selectedIndex == 0 ? 'Statistics' : 'Edit Habit',
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
          Positioned(
            top: 100,
            left: -80,
            child: BlurCircle(
              color: theme.colorScheme.primary.withOpacity(0.08),
              size: 260,
            ),
          ),
          Positioned(
            bottom: 160,
            right: -80,
            child: BlurCircle(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              size: 300,
            ),
          ),
          SafeArea(
            bottom: false,
            // CHANGED: Replaced IndexedStack with PageView for swiping support
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Update the bottom nav index when the user swipes
                setState(() => _selectedIndex = index);
              },
              children: [
                HabitStatsView(accentColor: _accent, habit: widget.habit),
                EditHabitView(access: access),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: EditHabitBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          // Animate the PageView when a bottom nav item is tapped
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
