import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/info_stat_card.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/mini_bar_chart.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/shared_habit_widgets.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/streak_progress_card.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/weekly_streak_progress_card.dart';

class HabitStatsView extends StatelessWidget {
  final Color accentColor;
  final Habit habit;

  const HabitStatsView({
    super.key,
    required this.accentColor,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<HabitStats?>(
      create: (context) {
        final db = context.read<AppDatabase>();
        return StatsService(db).watchHabitStats(habit);
      },
      initialData: null,
      child: _HabitStatsContent(accentColor: accentColor, habit: habit),
    );
  }
}

class _HabitStatsContent extends StatelessWidget {
  final Color accentColor;
  final Habit habit;

  const _HabitStatsContent({required this.accentColor, required this.habit});

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stats = context.watch<HabitStats?>();
    final isLoading = stats == null;

    // 🟢 Added the unit directly to the Total Done text
    final totalText = isLoading ? '—' : '${stats.totalDone} ${habit.unit}';

    final compText = isLoading
        ? '—%'
        : '${(stats.completionRate * 100).toStringAsFixed(0)}%';
    final chartValues = isLoading
        ? [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        : stats.last7DaysProgress;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Habit Icon & Title (Read-Only) ──
          Center(
            child: Column(
              children: [
                Container(
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
                  child: Icon(
                    _getIconFromId(habit.icon),
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  habit.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (habit.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    habit.description!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          if (habit.frequencyType == 'WEEKLY')
            WeeklyStreakProgressCard(
              habit: habit,
              accentColor: accentColor,
              stats: stats,
            )
          else
            StreakProgressCard(
              habit: habit,
              accentColor: accentColor,
              stats: stats,
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InfoStatCard(
                  label: 'Total Done',
                  value: totalText,
                  icon: LucideIcons.circleCheckBig,
                  color: accentColor,
                  infoTitle: 'Total Done',
                  infoDescription:
                      'The absolute sum of all your logs across all time for this habit.',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoStatCard(
                  label: 'Completion',
                  value: compText,
                  icon: LucideIcons.chartNoAxesColumn,
                  color: accentColor,
                  infoTitle: 'Completion Rate',
                  infoDescription:
                      'Your consistency score. It shows the percentage of scheduled days where you successfully hit your target.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Chart ──
          HabitCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel(label: 'LAST 7 DAYS'),
                    if (isLoading)
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accentColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                MiniBarChart(accentColor: accentColor, values: chartValues),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Start Date ──
          HabitCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Text(
                  'Started on',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(habit.startDate),
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
}
