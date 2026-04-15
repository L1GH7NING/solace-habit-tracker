import 'dart:math' as math;

import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeOutBack,
            offset: visible ? Offset.zero : const Offset(0, -1.2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: visible ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF19163A),
                      Color(0xFF2D1E68),
                      Color(0xFFF18A54),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D1E68).withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -18,
                      top: -28,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -24,
                      bottom: -38,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _CelebrationAnimationPlaceholder(
                            key: ValueKey(animationSeed),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.84),
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}

class _CelebrationAnimationPlaceholder extends StatefulWidget {
  const _CelebrationAnimationPlaceholder({super.key});

  @override
  State<_CelebrationAnimationPlaceholder> createState() =>
      _CelebrationAnimationPlaceholderState();
}

class _CelebrationAnimationPlaceholderState
    extends State<_CelebrationAnimationPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final pulse = 0.96 + (0.08 * math.sin(t * math.pi));
          final sparkleLift = 6 * math.sin(t * math.pi);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF2B5), Color(0xFFFFC96B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFC96B).withOpacity(0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF5A3A00),
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                top: 4 - sparkleLift,
                right: 4,
                child: _SparkleDot(
                  size: 14,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              Positioned(
                left: 2,
                bottom: 8 - (sparkleLift * 0.6),
                child: const _SparkleDot(
                  size: 10,
                  color: Color(0xFFFFD37B),
                ),
              ),
              Positioned(
                right: 6,
                bottom: 2 + (sparkleLift * 0.3),
                child: _SparkleDot(
                  size: 8,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SparkleDot extends StatelessWidget {
  final double size;
  final Color color;

  const _SparkleDot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}
