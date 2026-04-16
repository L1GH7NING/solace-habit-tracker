import 'dart:async'; // Import for the Timer

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/utils/log_habit_handler.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final double currentProgress;
  final bool canLog; // Used to decide to show/hide the action log button
  final bool canJournal; // NEW: Controls if the journal slide action is enabled
  final VoidCallback onTap;
  final Function(double value) onLog;

  /// Called when the user confirms the action by tapping the 'X' icon.
  /// Should delete all HabitCompletions for this habit on the current date.
  final VoidCallback? onUndo;

  const HabitCard({
    super.key,
    required this.habit,
    required this.currentProgress,
    this.canLog = true,
    this.canJournal = true, // NEW: Default to true
    required this.onTap,
    required this.onLog,
    this.onUndo,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with TickerProviderStateMixin {
  bool _isUndoConfirmationVisible = false;
  Timer? _undoTimer;

  // Controller is only needed if journaling is possible. We initialize it
  // lazily or in initState and it will simply be unused if canJournal is false.
  late final SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    // The controller and listener are lightweight. It's safe to always
    // initialize them. They will only be active if a Slidable is in the tree.
    _slidableController = SlidableController(this)
      ..animation.addStatusListener(_onSlideStatusChanged);
  }

  @override
  void dispose() {
    _slidableController.animation.removeStatusListener(_onSlideStatusChanged);
    _slidableController.dispose();
    _undoTimer?.cancel();
    super.dispose();
  }

  void _onSlideStatusChanged(AnimationStatus status) {
    // This check is important. Only proceed if journaling is enabled for this card.
    if (!widget.canJournal) return;

    if (status == AnimationStatus.completed) {
      final habitColor = AdaptiveColors.accent(
        context,
        Color(widget.habit.color),
      );
      _showJournalBottomSheet(context, habitColor);
      _slidableController.close();
    }
  }

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  void _handleActionTap(BuildContext context, bool isDone) {
    if (isDone) {
      if (_isUndoConfirmationVisible) {
        _undoTimer?.cancel();
        HapticFeedback.mediumImpact();
        widget.onUndo?.call();
      } else {
        HapticFeedback.lightImpact();
        setState(() {
          _isUndoConfirmationVisible = true;
        });

        _undoTimer?.cancel();
        _undoTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isUndoConfirmationVisible = false;
            });
          }
        });
      }
    } else {
      HapticFeedback.lightImpact();
      handleLog(context: context, habit: widget.habit, onLog: widget.onLog);
    }
  }

  void _showJournalBottomSheet(BuildContext context, Color color) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.bookOpen, color: color),
                const SizedBox(width: 12),
                Text(
                  'Journal',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Habit: ${widget.habit.title}',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Dummy Journal content goes here.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = widget.habit.targetValue;
    final isDone = widget.currentProgress >= target;
    final progress = target > 0
        ? (widget.currentProgress / target).clamp(0.0, 1.0)
        : 0.0;
    final habitColor = AdaptiveColors.accent(
      context,
      Color(widget.habit.color),
    );

    final progressText = widget.currentProgress.toStringAsFixed(
      widget.currentProgress.truncateToDouble() == widget.currentProgress
          ? 0
          : 1,
    );
    final targetText = target.toStringAsFixed(
      target.truncateToDouble() == target ? 0 : 1,
    );

    if (!isDone && _isUndoConfirmationVisible) {
      _isUndoConfirmationVisible = false;
      _undoTimer?.cancel();
    }

    // Define the core, non-slidable card content as a separate widget.
    // This makes the conditional logic below cleaner.
    final cardContent = GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border(left: BorderSide(color: habitColor, width: 4)),
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
            widget.canLog
                ? GestureDetector(
                    onTap: () => _handleActionTap(context, isDone),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: isDone && _isUndoConfirmationVisible
                            ? theme.colorScheme.error
                            : habitColor,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isDone
                              ? (_isUndoConfirmationVisible
                                    ? LucideIcons.x
                                    : LucideIcons.check)
                              : LucideIcons.penLine,
                          key: ValueKey<String>(
                            isDone
                                ? (_isUndoConfirmationVisible
                                      ? 'confirm_undo'
                                      : 'done')
                                : 'log',
                          ),
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: 36, height: 36),
          ],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        // *** CORE CHANGE IS HERE ***
        // Use a ternary operator to conditionally render the Slidable
        // or just the card content itself.
        child: widget.canJournal
            ? Slidable(
                key: ValueKey('slidable_journal_${widget.habit.id}'),
                controller: _slidableController,
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.35,
                  children: [
                    CustomSlidableAction(
                      onPressed: (context) {
                        _showJournalBottomSheet(context, habitColor);
                      },
                      padding: EdgeInsets.zero, // important
                      backgroundColor:
                          Colors.transparent, // remove default color
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
                          ), // match your card radius
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
                child: cardContent,
              )
            : cardContent, // If canJournal is false, render the card without the slidable wrapper.
      ),
    );
  }
}
