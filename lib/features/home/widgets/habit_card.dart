import 'dart:async'; // Import for the Timer

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/utils/log_habit_handler.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final double currentProgress;
  final VoidCallback onTap;
  final Function(double value) onLog;

  /// Called when the user confirms the action by tapping the 'X' icon.
  /// Should delete all HabitCompletions for this habit on the current date.
  final VoidCallback? onUndo;

  const HabitCard({
    super.key,
    required this.habit,
    required this.currentProgress,
    required this.onTap,
    required this.onLog,
    this.onUndo,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  // State to track if the 'X' icon should be shown for confirmation
  bool _isUndoConfirmationVisible = false;
  Timer? _undoTimer;

  @override
  void dispose() {
    // Cancel the timer when the widget is removed from the tree to prevent memory leaks
    _undoTimer?.cancel();
    super.dispose();
  }

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  void _handleActionTap(BuildContext context, bool isDone) {
    if (isDone) {
      // Habit is completed, handle the undo logic
      if (_isUndoConfirmationVisible) {
        // This is the SECOND tap (on the 'X' icon). Perform the undo action.
        _undoTimer?.cancel(); // Stop the timer
        HapticFeedback.mediumImpact();
        widget.onUndo?.call(); // Execute the callback to delete logs
        // We don't need to set state here, as the parent widget will rebuild
        // the card with new progress, which will hide the confirmation state naturally.
      } else {
        // This is the FIRST tap (on the '✓' icon). Show the 'X' for confirmation.
        HapticFeedback.lightImpact();
        setState(() {
          _isUndoConfirmationVisible = true;
        });

        // Start a timer to automatically revert to the checkmark if not confirmed
        _undoTimer?.cancel(); // Cancel any existing timer
        _undoTimer = Timer(const Duration(seconds: 3), () {
          // Check if the widget is still mounted before calling setState
          if (mounted) {
            setState(() {
              _isUndoConfirmationVisible = false;
            });
          }
        });
      }
    } else {
      // Habit is not completed, show the logging dialog
      HapticFeedback.lightImpact();
      handleLog(context: context, habit: widget.habit, onLog: widget.onLog);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = widget.habit.targetValue;
    final isDone = widget.currentProgress >= target;
    final progress = target > 0
        ? (widget.currentProgress / target).clamp(0.0, 1.0)
        : 0.0;
    final habitColor = AdaptiveColors.accent(context, Color(widget.habit.color));

    final progressText = widget.currentProgress.toStringAsFixed(
      widget.currentProgress.truncateToDouble() == widget.currentProgress ? 0 : 1,
    );
    final targetText = target.toStringAsFixed(
      target.truncateToDouble() == target ? 0 : 1,
    );
    
    // If the habit is no longer 'done', we should not be in the confirmation state.
    if (!isDone && _isUndoConfirmationVisible) {
      _isUndoConfirmationVisible = false;
      _undoTimer?.cancel();
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border(left: BorderSide(color: habitColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: habitColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                getIconFromId(widget.habit.icon),
                size: 32,
                color: habitColor,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (widget.habit.habitTime != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      Utilities.formatMinutes(widget.habit.habitTime!, context),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  if (isDone)
                    Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                habitColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$progressText / $targetText ${widget.habit.unit}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Action button
            GestureDetector(
              onTap: () => _handleActionTap(context, isDone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  // Show an error color during confirmation for better UX
                  color: isDone && _isUndoConfirmationVisible
                      ? theme.colorScheme.error
                      : habitColor,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    // Determine which icon to show based on state
                    isDone
                        ? (_isUndoConfirmationVisible ? LucideIcons.x : LucideIcons.check)
                        : LucideIcons.penLine,
                    // Use a unique key for each icon to ensure AnimatedSwitcher works correctly
                    key: ValueKey<String>(
                      isDone
                          ? (_isUndoConfirmationVisible ? 'confirm_undo' : 'done')
                          : 'log',
                    ),
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}