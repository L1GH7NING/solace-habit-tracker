import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/core/theme/adaptive_colors.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';

class HabitListTile extends StatefulWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitListTile({super.key, required this.habit, required this.onTap});

  @override
  State<HabitListTile> createState() => _HabitListTileState();
}

class _HabitListTileState extends State<HabitListTile> {
  bool _isPressed = false;

  IconData _iconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
      if (value) {
        HapticFeedback.selectionClick();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitColor = AdaptiveColors.accent(context, Color(widget.habit.color));
    final frequency = widget.habit.frequencyType == 'DAILY' ? 'day' : 'week';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        onTapCancel: () => _setPressed(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            elevation: _isPressed ? 1 : 2,
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                // ✅ Border and borderRadius restored here
                borderRadius: BorderRadius.circular(18), 
                border: Border(left: BorderSide(color: habitColor, width: 4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: habitColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Icon(_iconFromId(widget.habit.icon),
                        size: 32, color: habitColor),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            _Pill(
                              label:
                                  '${_formatValue(widget.habit.targetValue)} ${widget.habit.unit} / $frequency',
                              color: habitColor,
                              theme: theme,
                            ),
                            if (widget.habit.habitTime != null) ...[
                              const SizedBox(width: 6),
                              _Pill(
                                label: Utilities.formatMinutes(
                                    widget.habit.habitTime!, context),
                                color: theme.colorScheme.onSurfaceVariant,
                                theme: theme,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ✅ Arrow icon restored for navigation affordance
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatValue(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  String _formatFrequencyDays(String raw) {
    final days = raw
        .replaceAll(RegExp(r'[^a-zA-Z,]'), '')
        .toUpperCase()
        .split(',')
        .where((s) => s.isNotEmpty)
        .toList();
    if (days.length == 7) return 'Every day';
    if (days.length <= 3) return days.join(', ');
    return '${days.length}x / week';
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final ThemeData theme;

  const _Pill({required this.label, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}