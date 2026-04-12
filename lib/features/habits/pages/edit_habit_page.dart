// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart'; // ⚠️ adjust path
import 'package:zenith_habit_tracker/features/habits/controllers/edit_habit_controller.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/appearance_bottom_sheet.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/shared_habit_widgets.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({super.key, required this.habit});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage>
    with SingleTickerProviderStateMixin {
  late final EditHabitController _controller;
  late final TabController _tabController;

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

    _tabController = TabController(length: 2, vsync: this);

    // Pre-fill time from existing habit
    if (widget.habit.habitTime != null) {
      _hasTime = true;
      _selectedTime = Utilities.minutesToTimeOfDay(widget.habit.habitTime!);
    } else {
      _hasTime = false;
      _selectedTime = const TimeOfDay(hour: 8, minute: 30);
    }

    if (!iconOptions.any((opt) => opt.id == _controller.selectedIcon)) {
      _controller.selectedIcon = iconOptions.first.id;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});
  Color get _accent => Color(_controller.selectedColor);

  IconData get _currentIconData {
    return iconOptions
        .firstWhere(
          (opt) => opt.id == _controller.selectedIcon,
          orElse: () => iconOptions.first,
        )
        .icon;
  }

  void _handleSave() async {
    int? habitMinutes;
    if (_hasTime) {
      habitMinutes = Utilities.timeToMinutes(_selectedTime);
    }

    int? reminderMinutes;
    if (_hasTime && _reminderEnabled) {
      reminderMinutes = (habitMinutes! - _selectedReminderOffset)
          .clamp(0, 1440);
    }

    await _controller.saveHabit(
      habitTime: habitMinutes,
      reminderTime: reminderMinutes,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Habit updated successfully!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          margin:
              const EdgeInsets.only(bottom: 110, left: 20, right: 20),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Edit Habit',
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
        // 🗑️ Delete button in top right
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: _controller.deleteHabit,
              style: IconButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.error.withOpacity(0.1),
                shape: const CircleBorder(),
              ),
              icon: Icon(
                LucideIcons.trash2,
                size: 18,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Blobs
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
            child: Column(
              children: [
                // ── Edit / Stats tab bar ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      padding: const EdgeInsets.all(4),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          theme.colorScheme.onSurfaceVariant,
                      tabs: const [
                        Tab(text: 'Edit'),
                        Tab(text: 'Stats'),
                      ],
                    ),
                  ),
                ),

                // ── Tab views ────────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEditTab(theme),
                      _buildStatsTab(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Edit Tab ──────────────────────────────────────────────────────────────
  Widget _buildEditTab(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildMainIcon(context, theme),
          const SizedBox(height: 32),
          const SectionLabel(label: "HABIT NAME"),
          const SizedBox(height: 10),
          _buildNameInput(theme),
          const SizedBox(height: 8),
          _buildDescriptionInput(theme),
          const SizedBox(height: 28),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildFrequencyCard(theme)),
                const SizedBox(width: 14),
                Expanded(child: _buildGoalCard(theme)),
              ],
            ),
          ),
          if (_controller.frequencyType == 'WEEKLY') ...[
            const SizedBox(height: 16),
            _buildDayPicker(theme),
          ],
          const SizedBox(height: 28),
          _buildTimeCard(theme),
          const SizedBox(height: 16),
          _buildReminderRow(theme),
          const SizedBox(height: 28),
          _buildSaveButton(theme),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // ── Stats Tab ─────────────────────────────────────────────────────────────
  Widget _buildStatsTab(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Current Streak',
                  value: '—',
                  icon: LucideIcons.flame,
                  color: _accent,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Best Streak',
                  value: '—',
                  icon: LucideIcons.trophy,
                  color: _accent,
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Done',
                  value: '—',
                  icon: LucideIcons.checkCircle,
                  color: _accent,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Completion',
                  value: '—%',
                  icon: LucideIcons.barChart2,
                  color: _accent,
                  theme: theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Placeholder chart area
          HabitCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(label: 'LAST 7 DAYS'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    final heights = [0.4, 0.8, 0.6, 1.0, 0.3, 0.7, 0.0];
                    return _MiniBar(
                      label: days[i],
                      fill: heights[i],
                      color: _accent,
                      theme: theme,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Stats coming soon — connect your backend to see data here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Created date
          HabitCard(
            padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Icon(LucideIcons.calendar,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 10),
                Text(
                  'Started on',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(widget.habit.startDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ── Shared form widgets (mirrors CreateHabitPage exactly) ─────────────────

  Widget _buildMainIcon(BuildContext context, ThemeData theme) {
    return Center(
      child: GestureDetector(
        onTap: () => showAppearancePicker(
          context,
          controller: _controller,
          onUpdate: _rebuild,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(_currentIconData, size: 48, color: Colors.white),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.background,
                  width: 3,
                ),
              ),
              child: Icon(LucideIcons.pencil, size: 14, color: _accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput(ThemeData theme) {
    return TextField(
      controller: _controller.titleController,
      style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
      decoration: InputDecoration(
        hintText: 'Enter habit name...',
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDescriptionInput(ThemeData theme) {
    return TextField(
      controller: _controller.descriptionController,
      maxLines: 2,
      style: theme.textTheme.bodyMedium
          ?.copyWith(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Add a description (optional)',
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFrequencyCard(ThemeData theme) {
    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'FREQUENCY'),
          const SizedBox(height: 12),
          ...['DAILY', 'WEEKLY'].map((f) {
            final isActive = _controller.frequencyType == f;
            final label = f[0] + f.substring(1).toLowerCase();
            final icon = f == 'DAILY'
                ? Icons.calendar_today_rounded
                : Icons.date_range_rounded;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  _controller.setFrequency(f);
                  _rebuild();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? _accent
                        : theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(icon,
                          size: 16,
                          color: isActive
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: isActive
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalCard(ThemeData theme) {
    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'DAILY GOAL'),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    _controller.decrementTarget();
                    _rebuild();
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${_controller.targetCount}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: _accent,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'TIMES',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CircleButton(
                  icon: Icons.add_rounded,
                  filled: true,
                  fillColor: _accent,
                  onTap: () {
                    _controller.incrementTarget();
                    _rebuild();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (_controller.targetCount / 10).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: theme.colorScheme.secondaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Per day',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color:
                    theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPicker(ThemeData theme) {
    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'WHICH DAYS?'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((day) {
              final isActive = _controller.frequencyDays.contains(day);
              return GestureDetector(
                onTap: () {
                  _controller.toggleFrequencyDay(day);
                  _rebuild();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _accent
                        : theme.colorScheme.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? Colors.transparent
                          : theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.15),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day[0],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isActive
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(ThemeData theme) {
    return HabitCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time_rounded,
                    color: _accent, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                'Habit Time',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Switch(
                value: _hasTime,
                onChanged: (val) => setState(() => _hasTime = val),
                activeColor: _accent,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: !_hasTime
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Anytime',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null) {
                          setState(() => _selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _accent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(ThemeData theme) {
    return HabitCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_active_rounded,
                    color: _accent, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                'Remind Me',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Switch(
                value: _reminderEnabled,
                onChanged: (val) =>
                    setState(() => _reminderEnabled = val),
                activeColor: _accent,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: (!_hasTime || !_reminderEnabled)
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.cornerDownRight,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.5),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Remind me',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 38,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<int>(
                            value: _selectedReminderOffset,
                            underline: const SizedBox(),
                            icon: Icon(Icons.keyboard_arrow_down,
                                size: 18, color: _accent),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _accent,
                              fontSize: 14,
                            ),
                            items: _reminderOptions.map((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value >= 60
                                      ? '${value ~/ 60} hr'
                                      : '$value min',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(
                                    () => _selectedReminderOffset = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'before',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'Save Changes',
              style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  final String label;
  final double fill;
  final Color color;
  final ThemeData theme;

  const _MiniBar({
    required this.label,
    required this.fill,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 80 * fill,
          decoration: BoxDecoration(
            color: fill > 0 ? color.withOpacity(0.8) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: fill == 0
                ? Border.all(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.1))
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}