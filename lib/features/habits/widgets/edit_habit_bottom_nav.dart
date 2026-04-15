// lib/features/habits/widgets/edit_habit_bottom_nav.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/core/theme/app_theme.dart';

class EditHabitBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const EditHabitBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ✨ Fetch the custom acrylic properties from your ThemeExtension
    final acrylic = theme.extension<AcrylicTheme>()!;

    return Container(
      // Padding matches the main nav for consistency
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
      child: Container(
        // ✨ OUTER SHADOW FROM THEME
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
            // ✨ REFINED BLUR
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                // ✨ DYNAMIC COLORS FROM THEME
                color: acrylic.backgroundColor,
                borderRadius: BorderRadius.circular(30),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, Icons.leaderboard_rounded, 'Stats', theme),
                      _buildNavItem(1, Icons.edit_rounded, 'Edit', theme),
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

  Widget _buildNavItem(int index, IconData icon, String label, ThemeData theme) {
    final isActive = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48, // Slightly taller to match main nav feel
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(24),
          // ✨ ACTIVE GLOW
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.4),
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}