import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/home/widgets/log_habit_sheet.dart';

void handleLog({
  required BuildContext context,
  required Habit habit,
  required Function(double value) onLog,
}) {
  if (habit.unit.toLowerCase() == 'times') {
    onLog(1.0);
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (ctx) {
      return _AnimatedSheetWrapper(
        child: LogHabitSheet(habit: habit, onLog: onLog),
      );
    },
  );
}

class _AnimatedSheetWrapper extends StatefulWidget {
  final Widget child;

  const _AnimatedSheetWrapper({required this.child});

  @override
  State<_AnimatedSheetWrapper> createState() => _AnimatedSheetWrapperState();
}

class _AnimatedSheetWrapperState extends State<_AnimatedSheetWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
