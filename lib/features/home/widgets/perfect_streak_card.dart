// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/features/habits/services/stats_service.dart';

class PerfectStreakCard extends StatefulWidget {
  final PerfectStreakResult? result;

  const PerfectStreakCard({super.key, required this.result});

  @override
  State<PerfectStreakCard> createState() => _PerfectStreakCardState();
}

class _PerfectStreakCardState extends State<PerfectStreakCard> {
  int _prevStreak = 0;

  // true = number went up (slide in from bottom, exit to top)
  // false = number went down (slide in from top, exit to bottom)
  bool _isIncreasing = true;

  @override
  void didUpdateWidget(PerfectStreakCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldStreak = oldWidget.result?.currentStreak ?? 0;
    final newStreak = widget.result?.currentStreak ?? 0;

    if (newStreak != oldStreak) {
      setState(() {
        _isIncreasing = newStreak > oldStreak;
        _prevStreak = oldStreak;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    final isLoading = widget.result == null;
    final streak = widget.result?.currentStreak ?? 0;
    final best = widget.result?.bestStreak ?? 0;
    final last7 = widget.result?.last7Days ?? List.filled(7, false);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.28),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background fire watermark
          Positioned(
            right: -8,
            bottom: -8,
            child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(
                'assets/svgs/fire3.svg',
                width: 90,
                height: 90,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                Text(
                  'PERFECT STREAK',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Animated streak number ──────────────────────────────────
                SizedBox(
                  height:
                      44,
                  child: isLoading
                      ? _shimmer(width: 56, height: 40)
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            // Direction: increasing → new slides up from below
                            //            decreasing → new slides down from above
                            final inOffset = _isIncreasing
                                ? const Offset(0, 1) // enter from below
                                : const Offset(0, -1); // enter from above
                            final outOffset = _isIncreasing
                                ? const Offset(0, -1) // exit to top
                                : const Offset(0, 1); // exit to bottom

                            final isIncoming = child.key == ValueKey(streak);

                            final slideOffset = isIncoming
                                ? inOffset
                                : outOffset;

                            final slideAnimation =
                                Tween<Offset>(
                                  begin: slideOffset,
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: isIncoming
                                        ? Curves.easeOutCubic
                                        : Curves.easeInCubic,
                                  ),
                                );

                            return ClipRect(
                              child: FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: slideAnimation,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '$streak',
                            key: ValueKey(streak),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 2),

                Text(
                  'days in a row',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    height: 1,
                  ),
                ),

                const SizedBox(height: 10),

                // Best badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.trophy,
                        size: 10,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isLoading
                            ? 'Best: —'
                            : best == 1
                            ? 'Best: $best day'
                            : 'Best: $best days',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Last 7 dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final done = i < last7.length && last7[i];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? Colors.white
                            : Colors.white.withOpacity(0.25),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
