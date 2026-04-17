import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/habits/models/mood_model.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/journal_entry_card.dart';
import 'package:zenith_habit_tracker/features/home/services/journal_service.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/month_calendar.dart';

class HabitJournalView extends StatefulWidget {
  final int habitId;
  final JournalService journalService;
  final Color accentColor;

  const HabitJournalView({
    super.key,
    required this.habitId,
    required this.journalService,
    required this.accentColor,
  });

  @override
  State<HabitJournalView> createState() => _HabitJournalViewState();
}

class _HabitJournalViewState extends State<HabitJournalView> {
  DateTime? selectedDate;
  DateTime focusedMonth = DateTime.now();
  final DateTime today = DateTime.now();

  List<JournalEntry> _allEntries = [];
  bool _isLoading = true;

  // Stores a unique key for each date's journal card to scroll to it
  final Map<DateTime, GlobalKey> _entryKeys = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final entries = await widget.journalService
          .watchEntries(widget.habitId)
          .first;

      if (mounted) {
        setState(() {
          _allEntries = entries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Filters logs for the month currently shown in calendar
  List<JournalEntry> get _filteredMonthEntries {
    return _allEntries.where((entry) {
      return entry.date.year == focusedMonth.year &&
          entry.date.month == focusedMonth.month;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Helper: Maps the entry's integer mood to the Mood model
  Mood _getMoodObject(int? moodValue) {
    return moods.firstWhere(
      (m) => m.value == moodValue,
      orElse: () => moods[2],
    );
  }

  /// Handles clicking on a specific date on the calendar
  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });

    // 1. Check if an entry exists anywhere for this day
    final hasEntry = _allEntries.any((e) => DateUtils.isSameDay(e.date, date));

    // 2. If it doesn't exist, show a snackbar and abort
    if (!hasEntry) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "No entry for ${DateFormat('MMM d, yyyy').format(date)}.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 1),
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 4),
        ),
      );
      return;
    }

    // 3. If the date is in a different month, switch the month first
    if (date.year != focusedMonth.year || date.month != focusedMonth.month) {
      setState(() {
        focusedMonth = DateTime(date.year, date.month);
      });
      // Wait for the UI to build the new month's list before scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEntry(date);
      });
    } else {
      // Just scroll to it
      _scrollToEntry(date);
    }
  }

  /// Performs the actual smooth scroll down to the specific entry card
  void _scrollToEntry(DateTime date) {
    final dateOnly = DateUtils.dateOnly(date);
    final key = _entryKeys[dateOnly];

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        // Aligns the card near the top of the scrolling view (10% down)
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Set<DateTime> journalDates = _allEntries.map((e) => e.date).toSet();
    final entryCount = _filteredMonthEntries.length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthCalendar(
            today: today,
            selectedDate: selectedDate,
            journalDates: journalDates,
            accentColor: widget.accentColor,
            onDateSelected: _handleDateSelected,
            onMonthChanged: (newMonth) {
              setState(() {
                focusedMonth = newMonth;
                selectedDate = null;
              });
            },
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "$entryCount entries this month",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            ..._buildMonthView(theme),
        ],
      ),
    );
  }

  List<Widget> _buildMonthView(ThemeData theme) {
    final entries = _filteredMonthEntries;

    if (entries.isEmpty) {
      return [
        _buildEmptyState(
          theme,
          "No entries found for ${DateFormat('MMMM').format(focusedMonth)}.",
        ),
      ];
    }

    return entries.map((entry) {
      // Strip time data so we can reliably map keys by the day
      final dateOnly = DateUtils.dateOnly(entry.date);

      // Generate a persistent GlobalKey for this entry if one doesn't exist
      final key = _entryKeys.putIfAbsent(dateOnly, () => GlobalKey());

      // Wrap the card in a KeyedSubtree so Scrollable.ensureVisible can find it
      return KeyedSubtree(
        key: key,
        child: JournalEntryCard(
          date: entry.date,
          content: entry.content,
          mood: _getMoodObject(entry.mood),
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
