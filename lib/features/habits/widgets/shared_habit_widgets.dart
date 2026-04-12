import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HabitCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final Color? fillColor;

  const CircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: filled
              ? (fillColor ?? theme.colorScheme.primary)
              : theme.colorScheme.background,
          shape: BoxShape.circle,
          border: filled
              ? null
              : Border.all(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2)),
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}