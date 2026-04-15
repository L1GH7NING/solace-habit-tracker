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
      case 'liters':
        return ['0.25', '0.5', '1.0'];
      case 'ml':
        return ['100', '250', '500'];
      case 'steps':
        return ['1000', '2500', '5000'];
      case 'minutes':
        return ['10', '20', '30'];
      case 'hours':
        return ['0.5', '1', '2'];
      case 'calories':
        return ['100', '250', '500'];
      default:
        return ['1', '5', '10'];
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

  void _submitFromTextField() {
    if (_formKey.currentState!.validate()) {
      final value = double.tryParse(_textController.text);
      if (value != null) {
        _submit(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quickAddValues = _getQuickAddValues(widget.habit.unit);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    // 🔥 Direct Accent Color Extraction
    final Color accentColor = Color(widget.habit.color); 

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.50,
      maxChildSize: 0.90,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // 🔥 Drag Handle
              Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // 🔥 Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔥 HABIT ICON (Using the HabitTimeCard styling)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      getIconFromId(widget.habit.icon),
                      size: 24,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            letterSpacing: -0.5,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Log your progress",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            // letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔥 Premium Close Button
                  Material(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 24),
                      color: theme.colorScheme.onSurfaceVariant,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔥 CONTENT (Main Scrollable Sheet)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomPadding + keyboardPadding + 40),
                  children: [
                    // 🔥 QUICK ADD
                    Text(
                      'QUICK ADD',
                      style: theme.textTheme.labelMedium
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: quickAddValues.map((value) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: accentColor.withOpacity(0.1), // Themed Background
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _submit(double.parse(value)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Text(
                                  "$value ${widget.habit.unit}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: accentColor, // Themed Text
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // 🔥 CUSTOM INPUT
                    Text(
                      'CUSTOM AMOUNT',
                      style: theme.textTheme.labelMedium
                    ),
                    const SizedBox(height: 16),

                    Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _textController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                              ],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: accentColor, // Themed Cursor
                              decoration: InputDecoration(
                                hintText: '0.0',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                                ),
                                suffixText: widget.habit.unit,
                                suffixStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: accentColor, // Themed Focus Ring
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter value';
                                if (double.tryParse(value) == null) return 'Invalid number';
                                return null;
                              },
                              onFieldSubmitted: (_) => _submitFromTextField(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _submitFromTextField,
                            style: FilledButton.styleFrom(
                              backgroundColor: accentColor, // Themed Button
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // 🔥 MAIN BUTTON 
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _submit(widget.habit.targetValue),
                        icon: const Icon(Icons.check_circle_rounded, size: 22),
                        label: const Text("Mark as done"),
                        style: FilledButton.styleFrom(
                          backgroundColor: accentColor, // Themed Background
                          foregroundColor: Colors.white, // White icon and text
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}