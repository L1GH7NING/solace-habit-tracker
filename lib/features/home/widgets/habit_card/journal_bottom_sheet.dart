import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';

void showJournalBottomSheet(BuildContext context, Habit habit, Color color, DateTime selectedDate) {
  HapticFeedback.lightImpact();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => JournalBottomSheet(habit: habit, color: color, date: selectedDate),
  );
}

class JournalBottomSheet extends StatefulWidget {
  final Habit habit;
  final Color color;
  final DateTime date;

  const JournalBottomSheet({
    super.key,
    required this.habit,
    required this.color,
    required this.date,
  });

  @override
  State<JournalBottomSheet> createState() => _JournalBottomSheetState();
}

class _JournalBottomSheetState extends State<JournalBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  String getFormattedDate() {
    return DateFormat('EEEE, MMM d').format(widget.date);
  }

  void _handleSave() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      HapticFeedback.lightImpact();
      return;
    }
    // TODO: Save to DB here
    print("Saved journal: $text");
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const double navBarHeight = 80.0;

    // When keyboard is open, push content above it.
    // When keyboard is closed, content is padded above the navbar naturally.
    final double contentBottomPadding = keyboardHeight > 0
        ? keyboardHeight + 16
        : navBarHeight + 16;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ────────────────────────────────────────────
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
              padding: EdgeInsets.fromLTRB(20, 4, 12, contentBottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ───────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.bookOpen,
                          size: 20,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.habit.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              getFormattedDate(),
                              style: theme.textTheme.bodySmall,
                            ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Divider(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Text input ────────────────────────────────────────
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 160,
                      maxHeight: MediaQuery.of(context).size.height * 0.35,
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: false,
                      keyboardType: TextInputType.multiline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write your thoughts...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Save button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(LucideIcons.save),
                      label: const Text(
                        "Save Entry",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
