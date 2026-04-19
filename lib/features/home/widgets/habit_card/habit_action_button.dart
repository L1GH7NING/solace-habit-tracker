import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HabitActionButton extends StatelessWidget {
  final bool isDone;
  final bool isUndoVisible;
  final Color habitColor;
  final VoidCallback onTap;

  const HabitActionButton({
    super.key,
    required this.isDone,
    required this.isUndoVisible,
    required this.habitColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDone && isUndoVisible
              ? theme.colorScheme.error
              : habitColor,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isDone
                ? (isUndoVisible
                    ? LucideIcons.x
                    : LucideIcons.check)
                : LucideIcons.penLine,
            key: ValueKey(isUndoVisible),
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}