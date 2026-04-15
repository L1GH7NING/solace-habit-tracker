// lib/features/habits/widgets/edit_form_components.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/shared_habit_widgets.dart';

// --- Icon ---
class MainHabitIcon extends StatelessWidget {
  final Color accentColor;
  final IconData iconData;
  final VoidCallback onTap;
  const MainHabitIcon({
    super.key,
    required this.accentColor,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(iconData, size: 72, color: Colors.white),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(LucideIcons.pencil, size: 14, color: accentColor),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Text Inputs ---
class HabitNameInput extends StatelessWidget {
  final TextEditingController controller;
  const HabitNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
      decoration: InputDecoration(
        hintText: 'Enter habit name...',
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class HabitDescriptionInput extends StatelessWidget {
  final TextEditingController controller;
  const HabitDescriptionInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: 2,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Add a description (optional)',
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// --- Cards ---
class FrequencySelectorCard extends StatelessWidget {
  final Color accentColor;
  final String frequencyType;
  final ValueChanged<String> onChanged;
  const FrequencySelectorCard({
    super.key,
    required this.accentColor,
    required this.frequencyType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'FREQUENCY'),
          const SizedBox(height: 12),
          ...['DAILY', 'WEEKLY'].map((f) {
            final isActive = frequencyType == f;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onChanged(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? accentColor
                        : theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        f == 'DAILY'
                            ? Icons.calendar_today_rounded
                            : Icons.date_range_rounded,
                        size: 16,
                        color: isActive
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f[0] + f.substring(1).toLowerCase(),
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
}

class DayPickerCard extends StatelessWidget {
  final Color accentColor;
  final List<String> selectedDays;
  final ValueChanged<String> onDayToggle;
  const DayPickerCard({
    super.key,
    required this.accentColor,
    required this.selectedDays,
    required this.onDayToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'WHICH DAYS?'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((day) {
              final isActive = selectedDays.contains(day);
              return GestureDetector(
                onTap: () => onDayToggle(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive
                        ? accentColor
                        : theme.colorScheme.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? Colors.transparent
                          : theme.colorScheme.onSurfaceVariant.withOpacity(
                              0.15,
                            ),
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
}

class HabitTimeCard extends StatelessWidget {
  final bool hasTime;
  final TimeOfDay selectedTime;
  final Color accentColor;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeTap;
  const HabitTimeCard({
    super.key,
    required this.hasTime,
    required this.selectedTime,
    required this.accentColor,
    required this.onToggle,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Habit Time',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Switch(
                value: hasTime,
                onChanged: onToggle,
                activeThumbColor: accentColor,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: !hasTime
                ? Padding(padding: const EdgeInsets.only(top: 0))
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: onTimeTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: accentColor,
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
}

class ReminderCard extends StatelessWidget {
  final bool hasTime;
  final bool reminderEnabled;
  final int selectedOffset;
  final List<int> reminderOptions;
  final Color accentColor;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int?> onOffsetChanged;

  const ReminderCard({
    super.key,
    required this.hasTime,
    required this.reminderEnabled,
    required this.selectedOffset,
    required this.reminderOptions,
    required this.accentColor,
    required this.onToggle,
    required this.onOffsetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Remind Me',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Switch(
                value: reminderEnabled,
                onChanged: onToggle,
                activeThumbColor: accentColor,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: (!hasTime || !reminderEnabled)
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4, left: 20, right: 20),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.cornerDownRight,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.5,
                          ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<int>(
                            value: selectedOffset,
                            underline: const SizedBox(),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: accentColor,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                              fontSize: 14,
                            ),
                            items: reminderOptions.map((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value >= 60
                                      ? '${value ~/ 60} hr'
                                      : '$value min',
                                ),
                              );
                            }).toList(),
                            onChanged: onOffsetChanged,
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
}

// --- Buttons ---
class PrimaryGradientButton extends StatelessWidget {
  final String text; // <-- ADDED THIS
  final VoidCallback onPressed;
  const PrimaryGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
            ), // <-- USE THE TEXT PROPERTY
          ),
        ),
      ),
    );
  }
}

class DeleteHabitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteHabitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.error.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        icon: Icon(
          LucideIcons.trash2,
          size: 20,
          color: theme.colorScheme.error,
        ),
        label: Text(
          'Delete Habit',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
