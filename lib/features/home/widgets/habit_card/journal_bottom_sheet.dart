import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart';

void showJournalBottomSheet(
  BuildContext context,
  Habit habit,
  Color color,
  DateTime selectedDate,
  JournalService journalService,
) {
  HapticFeedback.lightImpact();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => JournalBottomSheet(
      habit: habit,
      color: color,
      date: selectedDate,
      journalService: journalService,
    ),
  );
}

class JournalBottomSheet extends StatefulWidget {
  final Habit habit;
  final Color color;
  final DateTime date;
  final JournalService journalService;

  const JournalBottomSheet({
    super.key,
    required this.habit,
    required this.color,
    required this.date,
    required this.journalService,
  });

  @override
  State<JournalBottomSheet> createState() => _JournalBottomSheetState();
}

class _JournalBottomSheetState extends State<JournalBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;
  JournalEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    // 1. Add listener to trigger rebuilds when user types
    _controller.addListener(_onTextChanged);
    _loadExistingEntry();
  }

  @override
  void dispose() {
    // 2. Clean up listener
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _canSave {
    if (_isSaving) return false;

    final currentText = _controller.text.trim();

    // Disable if empty
    if (currentText.isEmpty) return false;

    // If updating, disable if text is exactly the same as the original
    if (_existingEntry != null) {
      return currentText != _existingEntry!.content.trim();
    }

    return true;
  }

  IconData getIconFromId(String id) {
    return iconOptions
        .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
        .icon;
  }

  /// Pre-populate the field if an entry already exists for this day.
  Future<void> _loadExistingEntry() async {
    final entry = await widget.journalService
        .watchEntryForDate(widget.habit.id, widget.date)
        .first;
    if (entry != null && mounted) {
      setState(() {
        _existingEntry = entry;
        _controller.text = entry.content;
        _controller.selection = TextSelection.collapsed(
          offset: entry.content.length,
        );
      });
    }
  }

  String getFormattedDate() => DateFormat('EEEE, MMM d').format(widget.date);

  // Inside _JournalBottomSheetState in your UI file
  Future<void> _handleSave() async {
    if (!_canSave) return; // Extra safety check

    setState(() => _isSaving = true);

    try {
      await widget.journalService.saveEntry(
        habitId: widget.habit.id,
        content: _controller.text.trim(),
        date: widget.date,
      );
      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.pop(context);
        showAppSnackBar(context, "Journal Saved!", type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, 'Failed to save: $e', type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const double navBarHeight = 80.0;
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
                          getIconFromId(widget.habit.icon),
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
                              "Journal for ${getFormattedDate()}",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      // Delete button when editing an existing entry
                      if (_existingEntry != null)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            LucideIcons.trash2,
                            color: theme.colorScheme.error,
                            size: 18,
                          ),
                          onPressed: () async {
                            await widget.journalService.deleteEntry(
                              _existingEntry!.id,
                            );
                            if (mounted) Navigator.pop(context);
                          },
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
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.2,
                      ),
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
                      // 3. Button is disabled if _canSave is false
                      onPressed: _canSave ? _handleSave : null,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(LucideIcons.save),
                      label: Text(
                        _existingEntry != null ? "Update Entry" : "Save Entry",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        // 4. Change color to grey when disabled
                        backgroundColor: _canSave
                            ? widget.color
                            : theme.colorScheme.onSurface.withOpacity(0.12),
                        foregroundColor: _canSave
                            ? Colors.white
                            : theme.colorScheme.onSurface.withOpacity(0.38),
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
