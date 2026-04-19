import 'package:flutter/material.dart';

class GroupHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final ThemeData theme;

  const GroupHeader({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}