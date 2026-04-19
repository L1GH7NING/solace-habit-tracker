import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/edit_habit_controller.dart';
import 'package:zenith_habit_tracker/features/habits/views/habit_journal_view.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/edit_habit_bottom_nav.dart';
import 'package:zenith_habit_tracker/features/habits/views/edit_habit_view.dart';
import 'package:zenith_habit_tracker/features/habits/views/habits_stats_view.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/appearance_bottom_sheet.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class HabitInfoPage extends StatefulWidget {
  final String habitId;

  const HabitInfoPage({super.key, required this.habitId});

  @override
  State<HabitInfoPage> createState() => _HabitInfoPageState();
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

class _HabitInfoPageState extends State<HabitInfoPage> {
  late final AppDatabase _db;
  late final PageController _pageController;
  late final JournalService _journalService;

  EditHabitController? _controller;
  Habit? _habit;
  bool _loading = true;
  String? _error;

  int _selectedIndex = 1;

  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  bool _hasTime = false;
  bool _reminderEnabled = false;
  int _selectedReminderOffset = 15;
  final List<int> _reminderOptions = [5, 10, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    _db = Provider.of<AppDatabase>(context, listen: false);
    _journalService = JournalService(_db);
    _pageController = PageController(initialPage: _selectedIndex);
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    try {
      final habit = await _db.getHabitById(int.parse(widget.habitId));
      if (habit == null) {
        setState(() {
          _error = 'Habit not found.';
          _loading = false;
        });
        return;
      }

      final controller = EditHabitController(
        context: context,
        db: _db,
        habit: habit,
      );

      TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 30);
      bool hasTime = false;
      if (habit.habitTime != null) {
        hasTime = true;
        selectedTime = Utilities.minutesToTimeOfDay(habit.habitTime!);
      }

      if (mounted) {
        setState(() {
          _habit = habit;
          _controller = controller;
          _selectedTime = selectedTime;
          _hasTime = hasTime;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load habit.';
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Color get _accent =>
      AdaptiveColors.accent(context, Color(_controller!.selectedColor));

  IconData get _currentIconData {
    return iconOptions
        .firstWhere(
          (opt) => opt.id == _controller!.selectedIcon,
          orElse: () => iconOptions.first,
        )
        .icon;
  }

  void _showAppearancePicker() {
    showAppearancePicker(context, controller: _controller!, onUpdate: _rebuild);
  }

  void _handleSave() async {
    final habitMinutes = _hasTime
        ? Utilities.timeToMinutes(_selectedTime)
        : null;

    int? reminderMinutes;
    if (_hasTime && _reminderEnabled && habitMinutes != null) {
      reminderMinutes = (habitMinutes - _selectedReminderOffset).clamp(0, 1440);
    }

    await _controller!.saveHabit(
      habitTime: habitMinutes,
      reminderTime: reminderMinutes,
    );

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ── Loading ──────────────────────────────────────────────────────────────
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ── Error ────────────────────────────────────────────────────────────────
    if (_error != null || _habit == null || _controller == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Something went wrong.')),
      );
    }

    final habit = _habit!;

    final access = EditHabitPageStateAccess(
      controller: _controller!,
      habit: habit,
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
          _selectedIndex == 0
              ? 'Journals'
              : _selectedIndex == 1
              ? 'Statistics'
              : 'Edit Habit',
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
          SafeArea(
            bottom: false,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _selectedIndex = index),
              children: [
                HabitJournalView(
                  accentColor: Color(_habit!.color),
                  habitId: int.parse(widget.habitId),
                  journalService: _journalService,
                ),
                HabitStatsView(accentColor: _accent, habit: habit),
                EditHabitView(access: access),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: EditHabitBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
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
