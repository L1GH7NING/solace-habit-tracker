import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';

class LogHabitSheet extends StatefulWidget {
  final Habit habit;
  final Function(double value) onLog;

  const LogHabitSheet({super.key, required this.habit, required this.onLog});

  @override
  State<LogHabitSheet> createState() => _LogHabitSheetState();
}

class _LogHabitSheetState extends State<LogHabitSheet> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<String> _getQuickAddValues(String unit) {
    switch (unit.toLowerCase()) {
      case 'liters': return ['0.25', '0.5', '1.0'];
      case 'ml': return ['100', '250', '500'];
      case 'steps': return ['1k', '2.5k', '5k'];
      case 'minutes': return ['10', '20', '30'];
      default: return ['1', '5', '10'];
    }
  }

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  void _submit(double value) {
    HapticFeedback.lightImpact();
    if (value > 0) {
      widget.onLog(value);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accentColor = Color(widget.habit.color);
    
    // Get keyboard height
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const double navBarHeight = 80.0;

    final double bottomPadding = math.max(keyboardHeight, navBarHeight);

    // 1. Wrap the entire return statement in a Padding and SingleChildScrollView
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        // Makes the content scrollable so it doesn't overflow when the keyboard appears
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // Small Drag Handle
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                // 2. Fixed the massive 90px bottom padding here, changed it to 24.
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(getIconFromId(widget.habit.icon), size: 20, color: accentColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.habit.title,
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text("Log progress", style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quick Add Chips
                    Wrap(
                      spacing: 8,
                      children: _getQuickAddValues(widget.habit.unit).map((val) {
                        double numericVal = double.tryParse(val.replaceAll('k', '')) ?? 0;
                        if (val.contains('k')) numericVal *= 1000;
                        
                        return ActionChip(
                          label: Text("$val ${widget.habit.unit}"),
                          labelStyle: theme.textTheme.bodySmall?.copyWith(
                            color: accentColor, 
                            fontWeight: FontWeight.bold
                          ),
                          backgroundColor: accentColor.withOpacity(0.1),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () => _submit(numericVal),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Custom Input
                    Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _textController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Custom amount...',
                                suffixText: widget.habit.unit,
                                isDense: true,
                                contentPadding: const EdgeInsets.all(12),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: () {
                              final val = double.tryParse(_textController.text);
                              if (val != null) _submit(val);
                            },
                            style: IconButton.styleFrom(backgroundColor: accentColor),
                            icon: const Icon(Icons.add_rounded),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Main Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _submit(widget.habit.targetValue),
                        style: FilledButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Mark as done", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}