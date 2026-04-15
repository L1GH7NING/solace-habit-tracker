import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TopCelebrationBanner extends StatelessWidget {
  final bool visible;
  final String title;
  final String message;
  final int animationSeed;

  const TopCelebrationBanner({
    super.key,
    required this.visible,
    required this.title,
    required this.message,
    required this.animationSeed,
  });

  @override
  Widget build(BuildContext context) {
    // A clean, modern Emerald Success Green
    const Color emeraldGreen = Color(0xFF10B981);
    final theme = Theme.of(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: true,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              offset: visible ? Offset.zero : const Offset(0, -1.3),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: visible ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: emeraldGreen,
                    borderRadius: BorderRadius.circular(20),

                    /// ✨ CRISP MINIMAL BORDER
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),

                    /// 🌫 COHESIVE SHADOW
                    boxShadow: [
                      BoxShadow(
                        color: emeraldGreen.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _CelebrationIcon(key: ValueKey('icon_$animationSeed')),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: -0.5
                              )
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Lottie.asset(
        'assets/animations/Fire.json',
        repeat: true,
        fit: BoxFit.contain,
      ),
    );
  }
}
