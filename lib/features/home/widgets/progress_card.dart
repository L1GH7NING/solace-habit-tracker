// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final bool isToday;

  const ProgressCard({
    super.key,
    required this.completed,
    required this.total,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allDone = completed == total && total > 0;
    final progress = total > 0 ? completed / total : 0.0;
    final percent = total > 0 ? ((completed / total) * 100).round() : 0;

    final primaryColor = allDone ? Colors.green.shade500 : theme.colorScheme.primary;
    final trackColor = theme.colorScheme.primary.withOpacity(0.1);

    final headline = allDone
        ? '🎉 All done!'
        : completed == 0
            ? (isToday ? "Let's go!" : 'Nothing logged')
            : 'Keep going!';

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Matches PerfectStreakCard
        children: [
          // ── Label (Matched identical styling to Perfect Streak) ───────
          Text(
            'DAILY PROGRESS',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 8),

          // ── Big Percentage Number (Matched size/height to Streak) ─────
          SizedBox(
            height: 44,
            child: Text(
              '$percent%',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                height: 1,
                letterSpacing: -2,
              ),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            '$completed of $total habits',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1,
            ),
          ),

          const SizedBox(height: 10),

          // ── Status Badge (Matches Best Streak Badge) ──────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  allDone ? LucideIcons.circleCheck : LucideIcons.activity,
                  size: 10,
                  color: primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  headline,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Progress Bar (Matches the 7 dots height exactly) ──────────
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: AnimatedProgressBar(
              progress: progress,
              primaryColor: primaryColor,
              trackColor: trackColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted for clean animation
class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color primaryColor;
  final Color trackColor;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.primaryColor,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 7, // Exactly the same height as the 7 dots
          width: constraints.maxWidth,
          color: trackColor,
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            height: 7,
            width: constraints.maxWidth * progress,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      },
    );
  }
}