import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/common/widgets/snackbar.dart';
import 'package:zenith_habit_tracker/features/habits/models/mood_model.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart';

// ── Sheet entry point ─────────────────────────────────────────────────────────

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

// ── Widget ────────────────────────────────────────────────────────────────────

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
  int? _selectedMood; // 1–5

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _loadExistingEntry();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  bool get _canSave {
    if (_isSaving) return false;
    final text = _controller.text.trim();
    if (text.isEmpty) return false;
    if (_existingEntry != null) {
      final textChanged = text != _existingEntry!.content.trim();
      final moodChanged = _selectedMood != _existingEntry!.mood;
      return textChanged || moodChanged;
    }
    return true;
  }

  IconData getIconFromId(String id) => iconOptions
      .firstWhere((opt) => opt.id == id, orElse: () => iconOptions.first)
      .icon;

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
        _selectedMood = entry.mood;
      });
    }
  }

  String getFormattedDate() => DateFormat('EEEE, MMM d').format(widget.date);

  Future<void> _handleSave() async {
    if (!_canSave) return;
    setState(() => _isSaving = true);
    try {
      await widget.journalService.saveEntry(
        habitId: widget.habit.id,
        content: _controller.text.trim(),
        date: widget.date,
        mood: _selectedMood,
      );
      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.pop(context);
        showAppSnackBar(context, "Journal saved!", type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context,
          'Failed to save: $e',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDelete() async {
    await widget.journalService.deleteEntry(_existingEntry!.id);
    if (mounted) {
        context.pop();
        showAppSnackBar(context, "Journal Deleted", type: SnackBarType.warning);
      }
  }

  // ── Mood selector row ───────────────────────────────────────────────────────

  Widget _buildMoodSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        // Padding prevents the upward animation from clipping into the text above
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((mood) {
              final isSelected = _selectedMood == mood.value;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    // Tap selected mood again to deselect
                    _selectedMood = isSelected ? null : mood.value;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  // Shifts the item up slightly when selected
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -12.0 : 0.0,
                    0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glow Background & Emoji
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // Soft radial gradient glow instead of a round container
                          gradient: isSelected
                              ? RadialGradient(
                                  colors: [
                                    mood.color.withOpacity(0.4),
                                    mood.color.withOpacity(0.0),
                                  ],
                                  stops: const [0.2, 1.0],
                                )
                              : null,
                        ),
                        child: Center(
                          child: AnimatedScale(
                            scale: isSelected ? 1.25 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: SvgPicture.asset(
                              mood.assetPath,
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Label underneath the emoji
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? mood.color
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                        child: Text(mood.label),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

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
            // ── Drag handle ──────────────────────────────────────────────
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
                  // ── Header ─────────────────────────────────────────────
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
                              'Journal · ${getFormattedDate()}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (_existingEntry != null)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            LucideIcons.trash2,
                            color: theme.colorScheme.error,
                            size: 18,
                          ),
                          onPressed: _handleDelete,
                        ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Divider(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.15,
                      ),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // ── Mood selector ───────────────────────────────────────
                  _buildMoodSelector(theme),

                  const SizedBox(height: 24), // Added a bit more breathing room

                  // ── Text input ──────────────────────────────────────────
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 140,
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: false,
                      keyboardType: TextInputType.multiline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts...',
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

                  // ── Save button ─────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: FilledButton.icon(
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
                          _existingEntry != null
                              ? 'Update Entry'
                              : 'Save Entry',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: FilledButton.styleFrom(
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