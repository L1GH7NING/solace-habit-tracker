import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/home/utils/log_habit_handler.dart';

import 'habit_card_content.dart';
import 'habit_action_button.dart';
import 'habit_slidable_wrapper.dart';
import 'journal_bottom_sheet.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final double currentProgress;
  final bool canLog;
  final bool canJournal;
  final VoidCallback onTap;
  final Function(double value) onLog;
  final VoidCallback? onUndo;

  const HabitCard({
    super.key,
    required this.habit,
    required this.currentProgress,
    this.canLog = true,
    this.canJournal = true,
    required this.onTap,
    required this.onLog,
    this.onUndo,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with TickerProviderStateMixin {
  bool _isUndoConfirmationVisible = false;
  Timer? _undoTimer;
  late final SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this)
      ..animation.addStatusListener(_onSlideStatusChanged);
  }

  @override
  void dispose() {
    _slidableController.animation.removeStatusListener(
      _onSlideStatusChanged,
    );
    _slidableController.dispose();
    _undoTimer?.cancel();
    super.dispose();
  }

  void _onSlideStatusChanged(AnimationStatus status) {
    if (!widget.canJournal) return;

    if (status == AnimationStatus.completed) {
      final color = AdaptiveColors.accent(
        context,
        Color(widget.habit.color),
      );
      showJournalBottomSheet(context, widget.habit, color);
      _slidableController.close();
    }
  }

  void _handleActionTap(bool isDone) {
    if (isDone) {
      if (_isUndoConfirmationVisible) {
        _undoTimer?.cancel();
        HapticFeedback.mediumImpact();
        widget.onUndo?.call();
      } else {
        HapticFeedback.lightImpact();
        setState(() => _isUndoConfirmationVisible = true);

        _undoTimer?.cancel();
        _undoTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _isUndoConfirmationVisible = false);
          }
        });
      }
    } else {
      HapticFeedback.lightImpact();
      handleLog(
        context: context,
        habit: widget.habit,
        onLog: widget.onLog,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.habit.targetValue;
    final isDone = widget.currentProgress >= target;

    final progress = target > 0
        ? (widget.currentProgress / target).clamp(0.0, 1.0)
        : 0.0;

    final habitColor = AdaptiveColors.accent(
      context,
      Color(widget.habit.color),
    );

    if (!isDone && _isUndoConfirmationVisible) {
      _isUndoConfirmationVisible = false;
      _undoTimer?.cancel();
    }

    final actionButton = widget.canLog
        ? HabitActionButton(
            isDone: isDone,
            isUndoVisible: _isUndoConfirmationVisible,
            habitColor: habitColor,
            onTap: () => _handleActionTap(isDone),
          )
        : const SizedBox(width: 36, height: 36);

    final content = HabitCardContent(
      habit: widget.habit,
      progress: progress,
      currentProgress: widget.currentProgress,
      target: target,
      isDone: isDone,
      habitColor: habitColor,
      onTap: widget.onTap,
      actionButton: actionButton,
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
        child: widget.canJournal
            ? HabitSlidableWrapper(
                controller: _slidableController,
                habitId: widget.habit.id,
                color: habitColor,
                onJournalOpen: () =>
                    showJournalBottomSheet(context, widget.habit, habitColor),
                child: content,
              )
            : content,
      ),
    );
  }
}