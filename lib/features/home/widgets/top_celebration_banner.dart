import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopCelebrationBanner extends StatelessWidget {
  final bool visible;
  final String title;
  final String message;

  const TopCelebrationBanner({
    super.key,
    required this.visible,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              offset: visible ? Offset.zero : const Offset(0, -1.2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: visible ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    // 🌿 DARK success background
                    color: const Color(0xFF16A34A),

                    borderRadius: BorderRadius.circular(24),

                    // subtle border (almost invisible, adds polish)
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),

                    // deeper shadow for contrast
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const _Icon(),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // 👈 light text
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.85), // 👈 softer light
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
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
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        // 👇 lighter green bubble for contrast
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/svgs/check.svg',
        colorFilter: const ColorFilter.mode(
          Colors.white, // 👈 white icon pops nicely
          BlendMode.srcIn,
        ),
      ),
    );
  }
}