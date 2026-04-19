import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HabitSlidableWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onJournalOpen;
  final Color color;
  final SlidableController controller;
  final int habitId;

  const HabitSlidableWrapper({
    super.key,
    required this.child,
    required this.onJournalOpen,
    required this.color,
    required this.controller,
    required this.habitId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey('slidable_journal_$habitId'),
      controller: controller,
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.35,
        children: [
          CustomSlidableAction(
            onPressed: (_) => onJournalOpen(),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                LucideIcons.notebookPen,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}