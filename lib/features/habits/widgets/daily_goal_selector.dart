// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/shared_habit_widgets.dart';

// ── Unit definitions ──────────────────────────────────────────────────────────

enum HabitUnit {
  times,
  liters,
  ml,
  steps,
  minutes,
  hours,
  km,
  calories,
  custom;

  String get label => switch (this) {
    HabitUnit.times => 'times',
    HabitUnit.liters => 'liters',
    HabitUnit.ml => 'ml',
    HabitUnit.steps => 'steps',
    HabitUnit.minutes => 'minutes',
    HabitUnit.hours => 'hours',
    HabitUnit.km => 'km',
    HabitUnit.calories => 'calories',
    HabitUnit.custom => 'custom',
  };

  // Whether this unit uses the stepper instead of free text
  bool get isStepper => this == HabitUnit.times;

  // Whether decimals are allowed
  bool get allowsDecimal =>
      this == HabitUnit.liters || this == HabitUnit.ml || this == HabitUnit.km;

  // Inferred habit type for DB storage
  String get habitType => switch (this) {
    HabitUnit.times => 'count',
    HabitUnit.minutes || HabitUnit.hours => 'duration',
    _ => 'quantity',
  };
}

// ── DailyGoalSelector ─────────────────────────────────────────────────────────

class DailyGoalSelector extends StatefulWidget {
  final Color accentColor;
  final String habitName; // for live preview
  final String frequencyType; // ✅ ADDED THIS
  final double initialValue;
  final String initialUnit;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<String> onUnitChanged;

  const DailyGoalSelector({
    super.key,
    required this.accentColor,
    required this.habitName,
    required this.frequencyType, // ✅ ADDED THIS
    required this.onValueChanged,
    required this.onUnitChanged,
    this.initialValue = 1,
    this.initialUnit = 'times',
  });

  @override
  State<DailyGoalSelector> createState() => _DailyGoalSelectorState();
}

class _DailyGoalSelectorState extends State<DailyGoalSelector> {
  late double _value;
  late HabitUnit _unit;
  late TextEditingController _textController;
  late TextEditingController _customUnitController;
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _unit = HabitUnit.values.firstWhere(
      (u) => u.label == widget.initialUnit,
      orElse: () => HabitUnit.times,
    );
    _textController = TextEditingController(text: _formatValue(_value));
    _customUnitController = TextEditingController();

    // If we were given a custom unit not in the enum
    if (!HabitUnit.values.any((u) => u.label == widget.initialUnit)) {
      _unit = HabitUnit.custom;
      _customUnitController.text = widget.initialUnit;
      _showCustomInput = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _customUnitController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DailyGoalSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent provided new initial values (Preset selected)
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.initialUnit != widget.initialUnit) {
      setState(() {
        _value = widget.initialValue;

        // Check if unit is standard or custom
        final isStandardUnit = HabitUnit.values.any(
          (u) => u.label == widget.initialUnit,
        );
        if (isStandardUnit) {
          _unit = HabitUnit.values.firstWhere(
            (u) => u.label == widget.initialUnit,
          );
          _showCustomInput = false;
        } else {
          _unit = HabitUnit.custom;
          _customUnitController.text = widget.initialUnit;
          _showCustomInput = true;
        }

        // Update the text field with the new formatted number
        _textController.text = _formatValue(_value);
      });
    }
  }

  String _formatValue(double v) {
    if (_unit.allowsDecimal) {
      // Trim unnecessary trailing zeros
      return v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
    }
    return v.toInt().toString();
  }

  void _notifyParent() {
    widget.onValueChanged(_value);
    final unitStr = _unit == HabitUnit.custom
        ? (_customUnitController.text.isNotEmpty
              ? _customUnitController.text
              : 'unit')
        : _unit.label;
    widget.onUnitChanged(unitStr);
  }

  void _increment() {
    setState(() {
      _value = (_value + 1).clamp(1, 9999);
      _textController.text = _formatValue(_value);
    });
    _notifyParent();
  }

  void _decrement() {
    setState(() {
      _value = (_value - 1).clamp(1, 9999);
      _textController.text = _formatValue(_value);
    });
    _notifyParent();
  }

  void _onTextChanged(String raw) {
    final parsed = double.tryParse(raw);
    if (parsed != null && parsed > 0) {
      _value = _unit.allowsDecimal ? parsed : parsed.truncateToDouble();
      _notifyParent();
    }
  }

  void _onUnitSelected(HabitUnit unit) {
    setState(() {
      _unit = unit;
      _showCustomInput = unit == HabitUnit.custom;
      // Snap to int when switching to non-decimal unit
      if (!unit.allowsDecimal) {
        _value = _value.truncateToDouble().clamp(1, 9999);
      }
      _textController.text = _formatValue(_value);
    });
    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ Check frequency to adapt texts
    final isWeekly = widget.frequencyType.toUpperCase() == 'WEEKLY';

    return HabitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Dynamic title
          SectionLabel(label: isWeekly ? 'WEEKLY GOAL' : 'DAILY GOAL'),
          const SizedBox(height: 4),
          // ✅ Dynamic description
          Text(
            'How much do you want to complete per ${isWeekly ? 'week' : 'day'}?',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 20),

          // ── Input row ────────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: _unit.isStepper
                ? _buildStepper(theme)
                : _buildTextInput(theme),
          ),

          // ── Custom unit text field ────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _showCustomInput
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: _customUnitController,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter custom unit (e.g. pages)',
                        filled: true,
                        fillColor: theme.colorScheme.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) {
                        setState(() {});
                        _notifyParent();
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Stepper (for "times") ─────────────────────────────────────────────────
  Widget _buildStepper(ThemeData theme) {
    return Row(
      key: const ValueKey('stepper'),
      children: [
        // Minus
        _StepperButton(
          icon: Icons.remove_rounded,
          onTap: _decrement,
          theme: theme,
        ),
        const SizedBox(width: 12),

        // Value display
        Expanded(
          child: Column(
            children: [
              Text(
                _formatValue(_value),
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: widget.accentColor,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'TIMES',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Plus
        _StepperButton(
          icon: Icons.add_rounded,
          onTap: _increment,
          filled: true,
          fillColor: widget.accentColor,
          theme: theme,
        ),

        const SizedBox(width: 12),

        // Unit dropdown (still show for stepper so user can switch)
        _UnitDropdown(
          selected: _unit,
          accentColor: widget.accentColor,
          theme: theme,
          onSelected: _onUnitSelected,
        ),
      ],
    );
  }

  // ── Free text input (for all other units) ─────────────────────────────────
  Widget _buildTextInput(ThemeData theme) {
    return Row(
      key: const ValueKey('textinput'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Numeric input
        Expanded(
          child: TextField(
            controller: _textController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: _unit.allowsDecimal,
            ),
            inputFormatters: [
              if (_unit.allowsDecimal)
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              else
                FilteringTextInputFormatter.digitsOnly,
            ],
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: widget.accentColor,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.accentColor.withOpacity(0.08),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: widget.accentColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
            onChanged: _onTextChanged,
          ),
        ),

        const SizedBox(width: 12),

        // Unit dropdown
        _UnitDropdown(
          selected: _unit,
          accentColor: widget.accentColor,
          theme: theme,
          onSelected: _onUnitSelected,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool filled;
  final Color? fillColor;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.theme,
    this.filled = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
                ),
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

class _UnitDropdown extends StatelessWidget {
  final HabitUnit selected;
  final Color accentColor;
  final ThemeData theme;
  final ValueChanged<HabitUnit> onSelected;

  const _UnitDropdown({
    required this.selected,
    required this.accentColor,
    required this.theme,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: DropdownButton<HabitUnit>(
        value: selected,
        underline: const SizedBox(),
        isDense: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 16,
          color: accentColor,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: accentColor,
          fontSize: 13,
        ),
        dropdownColor: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        items: HabitUnit.values.map((unit) {
          return DropdownMenuItem(
            value: unit,
            child: Text(
              unit.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: unit == selected
                    ? accentColor
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: (unit) {
          if (unit != null) onSelected(unit);
        },
      ),
    );
  }
}
