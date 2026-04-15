// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart'; // ⚠️ adjust path
import 'package:zenith_habit_tracker/data/local/app_database.dart'; // ⚠️ adjust path

// 🛠️ Helper record to hold filtered day data for clarity
typedef ApplicableDay = ({DateTime date, bool isDone, String label});

class StreakProgressCard extends StatelessWidget {
  final Habit habit;
  final Color accentColor;
  final HabitStats? stats;

  const StreakProgressCard({
    super.key,
    required this.habit,
    required this.accentColor,
    required this.stats,
  });

  // 🛠️ Copied this helper from StatsService to determine which days are applicable
  bool _appliesOnDate(Habit habit, DateTime date) {
    // If frequencyDays is empty or null, it applies every day
    final daysString = habit.frequencyDays ?? '';
    if (daysString.trim().isEmpty) {
      return true;
    }
    final clean = daysString
        .replaceAll(RegExp(r'[^a-zA-Z,]'), '')
        .toUpperCase();
    final days = clean.split(',');
    const map = {
      1: 'MON',
      2: 'TUE',
      3: 'WED',
      4: 'THU',
      5: 'FRI',
      6: 'SAT',
      7: 'SUN',
    };
    return days.contains(map[date.weekday]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = stats == null;

    final currentStreak = stats?.currentStreak ?? 0;
    final currentValue = stats?.todayValue ?? 0.0;
    final target = habit.targetValue;
    final progress = target > 0 ? (currentValue / target).clamp(0.0, 1.0) : 0.0;

    final valueText = currentValue == currentValue.truncateToDouble()
        ? currentValue.toInt().toString()
        : currentValue.toStringAsFixed(1);
    final targetText = target == target.truncateToDouble()
        ? target.toInt().toString()
        : target.toStringAsFixed(1);

    // 🛠️ LOGIC TO FILTER DAYS:
    // 1. Get the raw completion data for the last 7 days.
    final last7Completions =
        stats?.last7DaysCompletion ?? List.filled(7, false);
    final List<ApplicableDay> applicableDays = [];

    if (stats != null) {
      final now = DateTime.now();
      const weekDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      // 2. Iterate through the last 7 calendar days
      for (int i = 0; i < 7; i++) {
        final date = now.subtract(Duration(days: 6 - i));

        // 3. Check if the habit was supposed to be done on this day
        if (_appliesOnDate(habit, date)) {
          // 4. If yes, add it to our display list
          applicableDays.add((
            date: date,
            isDone: last7Completions[i],
            label: weekDayNames[date.weekday - 1],
          ));
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: SvgPicture.asset('assets/svgs/fire3.svg'),
                  ),
                  const SizedBox(height: 8),
                  isLoading
                      ? _shimmer(theme, width: 50, height: 16)
                      : Text(
                          '$currentStreak days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                  Text(
                    'streak',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoading
                      ? _shimmer(theme, width: 100, height: 24)
                      : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: valueText,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: ' / $targetText ${habit.unit}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 12),
                  isLoading
                      ? _shimmer(theme, width: double.infinity, height: 8)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                color: accentColor.withOpacity(0.1),
                              ),
                              AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                                widthFactor: progress,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 14),

                  // 🛠️ UI RENDERING: Use the filtered list to build the dots.
                  // `spaceEvenly` distributes the dots nicely, regardless of how many there are.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: applicableDays.map((day) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: day.isDone
                                  ? Colors.green.shade500
                                  : theme.colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: day.isDone
                                    ? Colors.green.shade600
                                    : theme.colorScheme.outlineVariant,
                                width: 1.5,
                              ),
                            ),
                            child: day.isDone
                                ? const Icon(
                                    LucideIcons.check,
                                    size: 11,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day.label, // Use the pre-calculated label
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                              color: day.isDone
                                  ? Colors.green.shade600
                                  : theme.colorScheme.onSurfaceVariant
                                        .withOpacity(0.5),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmer(
    ThemeData theme, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
