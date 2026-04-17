// lib/features/common/widgets/bottom_nav.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenith_habit_tracker/core/theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final bool isGuest;

  const BottomNav({super.key, required this.isGuest});

  static int _indexForRoute(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/all')) return 1;
    if (location.startsWith('/add-habit')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final acrylic = theme.extension<AcrylicTheme>()!;
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexForRoute(location);
    final items = [
      Icons.home_rounded,
      Icons.list_rounded,
      Icons.add_circle_outline_rounded,
      Icons.group_rounded,
      Icons.person_rounded,
    ];

    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: acrylic.shadowColor,
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            // ✨ STRONGER BLUR
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                // ✨ ACRYLIC TINT
                // Using a lighter opacity (0.5 - 0.6) makes the blur more noticeable
                color: acrylic.backgroundColor,
                borderRadius: BorderRadius.circular(30),
                // ✨ CRISP BORDER (The "Acrylic" Edge)
                border: Border.all(
                  color: acrylic.borderColor,
                  width: 1.2,
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(items.length, (i) {
                      final isActive = i == selectedIndex;
                      return GestureDetector(
                        onTap: () {
                          switch (i) {
                            case 0: context.go('/home');
                            case 1: context.go('/all');
                            case 2: context.go('/add-habit');
                            case 3: context.go('/community');
                            case 4: context.go('/profile');
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            shape: BoxShape.circle,
                            // ✨ SUBTLE GLOW FOR ACTIVE ICON
                            boxShadow: isActive ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ] : [],
                          ),
                          child: Icon(
                            items[i],
                            color: isActive
                                ? Colors.white
                                : theme.colorScheme.onSurface.withOpacity(0.4),
                            size: i == 2 ? 30 : 24,
                          ),
                        ),
                      );
                    }),
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