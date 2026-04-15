// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart'; // ⚠️ adjust path
import 'package:zenith_habit_tracker/data/local/app_database.dart'; // ⚠️ adjust path

class WeeklyStreakProgressCard extends StatelessWidget {
  final Habit habit;
  final Color accentColor;
  final HabitStats? stats;

  const WeeklyStreakProgressCard({
    super.key,
    required this.habit,
    required this.accentColor,
    required this.stats,
  });

  /// Returns the Monday of the week containing [date]
  DateTime _startOfWeek(DateTime date) =>
      DateTime(date.year, date.month, date.day)
          .subtract(Duration(days: date.weekday - 1));

  /// Returns a short label for a week: "Jun 2", "Jun 9", etc.
  String _weekLabel(DateTime monday) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return '${months[monday.month - 1]} ${monday.day}';
  }

  /// Build the last 5 weeks (Mon–Sun windows) ending with the current week
  List<DateTime> _last5Weeks() {
    final today = DateTime.now();
    final thisMonday = _startOfWeek(today);
    return List.generate(5, (i) => thisMonday.subtract(Duration(days: (4 - i) * 7)));
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

    // Build week completion status from last7DaysCompletion.
    // last7DaysCompletion[6] = today, [5] = yesterday, etc.
    // For weekly habits the service anchors everything to Monday, so we just
    // need to check whether each of the last 5 weeks' Mondays was completed.
    final last5Weeks = _last5Weeks();
    final completionMap = stats?.weeklyCompletionMap ?? {};

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
            // ── Left: fire icon + streak (in weeks) ───────────────────────
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
                          // Weeks streak, not days
                          '$currentStreak ${currentStreak == 1 ? 'week' : 'weeks'}',
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

            // ── Right: value + bar + weekly completion dots ────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Value / target
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

                  // Progress bar (this week's progress)
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

                  // Last 5 weeks — one dot per week
                  isLoading
                      ? _shimmer(theme, width: double.infinity, height: 22)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: last5Weeks.map((monday) {
                            final done = completionMap[monday] == true;
                            final isCurrentWeek =
                                monday == _startOfWeek(DateTime.now());

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: done
                                        ? Colors.green.shade500
                                        : isCurrentWeek
                                            ? accentColor.withOpacity(0.15)
                                            : theme.colorScheme
                                                .surfaceContainerHighest,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: done
                                          ? Colors.green.shade600
                                          : isCurrentWeek
                                              ? accentColor.withOpacity(0.4)
                                              : theme.colorScheme.outlineVariant,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: done
                                      ? const Icon(Icons.check_rounded,
                                          size: 13, color: Colors.white)
                                      : isCurrentWeek
                                          ? Icon(Icons.circle,
                                              size: 6,
                                              color: accentColor)
                                          : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _weekLabel(monday),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    color: done
                                        ? Colors.green.shade600
                                        : isCurrentWeek
                                            ? accentColor
                                            : theme.colorScheme
                                                .onSurfaceVariant
                                                .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 6),

                  // Helper label
                  Text(
                    'Last 5 weeks',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmer(ThemeData theme,
      {required double width, required double height}) {
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