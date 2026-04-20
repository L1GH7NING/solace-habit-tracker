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

class _PerfectStreakCardState extends State<PerfectStreakCard>
    with SingleTickerProviderStateMixin {
  bool _isIncreasing = true;

  // Controller for the pulsating fire effect (50+ days)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start pulsing immediately if initial streak is >= 50
    if ((widget.result?.currentStreak ?? 0) >= 50) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PerfectStreakCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldStreak = oldWidget.result?.currentStreak ?? 0;
    final newStreak = widget.result?.currentStreak ?? 0;

    if (newStreak != oldStreak) {
      setState(() {
        _isIncreasing = newStreak > oldStreak;
      });

      // Handle Pulsating Effect Trigger
      if (newStreak >= 50) {
        if (!_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      } else {
        if (_pulseController.isAnimating || _pulseController.value > 0) {
          _pulseController.animateBack(0.0, duration: const Duration(milliseconds: 300));
        }
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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

    // ── TIER LOGIC (Fixed Gradient, Scaling Intensity) ──────────────────────
    double fireOpacity;
    double fireScale;
    double shadowOpacity;
    double shadowBlur;
    List<Shadow>? textGlow;

    if (streak >= 50) {
      // 💎 Zenith Tier (50+ Days) - Pulsates!
      fireOpacity = 0.5;
      fireScale = 1.45;
      shadowOpacity = 0.6;
      shadowBlur = 20;
      textGlow = [Shadow(color: Colors.white.withOpacity(0.9), blurRadius: 16)];
    } else if (streak >= 30) {
      // 🥇 Platinum Tier (30 - 49 Days)
      fireOpacity = 0.35;
      fireScale = 1.25;
      shadowOpacity = 0.45;
      shadowBlur = 15;
      textGlow = [Shadow(color: Colors.white.withOpacity(0.6), blurRadius: 12)];
    } else if (streak >= 14) {
      // 🔥 Gold Tier (14 - 29 Days)
      fireOpacity = 0.25;
      fireScale = 1.15;
      shadowOpacity = 0.35;
      shadowBlur = 12;
      textGlow = [Shadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)];
    } else if (streak >= 7) {
      // ⭐ Silver Tier (7 - 13 Days)
      fireOpacity = 0.18;
      fireScale = 1.05;
      shadowOpacity = 0.3;
      shadowBlur = 10;
      textGlow = null;
    } else {
      // 🔵 Base Tier (0 - 6 Days)
      fireOpacity = 0.12;
      fireScale = 0.85;
      shadowOpacity = 0.28;
      shadowBlur = 8;
      textGlow = null;
    }
    // ─────────────────────────────────────────────────────────────────────────

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary], // Gradient remains the same
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(shadowOpacity), // Shadow intensity scales up
            blurRadius: shadowBlur,
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
            child: AnimatedScale(
              duration: const Duration(milliseconds: 600),
              scale: fireScale,
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: fireOpacity,
                child: ScaleTransition(
                  scale: _pulseAnimation, // Pulsating effect applied here
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
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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

                // Animated streak number
                SizedBox(
                  height: 44,
                  child: isLoading
                      ? _shimmer(width: 56, height: 40)
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final inOffset = _isIncreasing
                                ? const Offset(0, 1)
                                : const Offset(0, -1);
                            final outOffset = _isIncreasing
                                ? const Offset(0, -1)
                                : const Offset(0, 1);

                            final isIncoming = child.key == ValueKey(streak);
                            final slideOffset = isIncoming ? inOffset : outOffset;

                            final slideAnimation = Tween<Offset>(
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
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                              letterSpacing: -2,
                              shadows: textGlow,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        color: done ? Colors.white : Colors.white.withOpacity(0.25),
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