// lib/features/common/widgets/bottom_nav.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  final bool isGuest;

  const BottomNav({super.key, required this.isGuest});

  static int _indexForRoute(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/stats')) return 1;
    if (location.startsWith('/add-habit')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexForRoute(location);
    final items = [
      Icons.home_rounded,
      Icons.leaderboard_rounded,
      Icons.add_circle_outline_rounded,
      Icons.group_rounded,
      Icons.person_rounded,
    ];

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      // REMOVED: color: Colors.transparent
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            color: theme.colorScheme.surface.withOpacity(0.75),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(items.length, (i) {
                    final isActive = i == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        switch (i) {
                          case 0: context.go('/home');
                          case 1: context.go('/stats');
                          case 2: context.go('/add-habit');
                          case 3: context.go('/community');
                          case 4: context.go('/profile');
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
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
                        ),
                        child: Icon(
                          items[i],
                          color: isActive
                              ? Colors.white
                              : theme.colorScheme.onSurface.withOpacity(0.3),
                          size: i == 2 ? 28 : 22,
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
    );
  }
}