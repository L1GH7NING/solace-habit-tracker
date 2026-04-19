import 'package:logger/logger.dart'; // Import logger
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';

class JournalService {
  final AppDatabase _db;

  // Initialize Logger
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
  );

  JournalService(this._db);

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  // ── Queries ────────────────────────────────────────────────────────────────

  Stream<List<JournalEntry>> watchEntries(int habitId) {
    _logger.d("Watching entries for habitId: $habitId");
    return _db.watchJournalEntries(habitId);
  }

  Stream<JournalEntry?> watchEntryForDate(int habitId, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _logger.d("Watching entry for habitId: $habitId on date: $normalizedDate");
    return _db.watchJournalEntryForDate(habitId, normalizedDate);
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  Future<JournalEntry> createEntry({
    required int habitId,
    required String content,
    required DateTime date,
    bool isCompleted = false,
    int? mood,
    List<String>? tags,
  }) async {
    try {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _logger.i(
        "Attempting to create entry for habit: $habitId on $normalizedDate",
      );

      final existing = await _db.getJournalEntryForDate(
        habitId,
        normalizedDate,
      );

      if (existing != null) {
        _logger.w(
          "Create failed: Entry already exists for habit: $habitId on $normalizedDate",
        );
        throw StateError(
          'Entry already exists for this date. Use saveEntry or updateEntry.',
        );
      }

      final now = DateTime.now();
      final companion = JournalEntriesCompanion.insert(
        habitId: habitId,
        userId: _currentUserId,
        content: content,
        date: normalizedDate,
        isCompleted: Value(isCompleted),
        mood: Value(mood),
        tags: Value(tags != null ? _encodeTags(tags) : null),
        createdAt: now,
        updatedAt: now,
        isSynced: const Value(false),
        pendingOperation: const Value('CREATE'),
      );

      await _db.insertJournalEntry(companion);
      _logger.t("Entry created successfully for habit: $habitId");

      return (await _db.getJournalEntryForDate(habitId, normalizedDate))!;
    } catch (e, stack) {
      _logger.e("Error in createEntry", error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> updateEntry({
    required JournalEntry entry,
    String? content,
    bool? isCompleted,
    int? mood,
    List<String>? tags,
  }) async {
    try {
      _logger.i("Updating entry ID: ${entry.id} (Habit: ${entry.habitId})");

      // We use the existing 'entry' to fill in required fields that aren't changing
      final companion = JournalEntriesCompanion(
        id: Value(entry.id),
        userId: Value(_currentUserId),
        // Required fields must be provided for .replace() to work
        habitId: Value(entry.habitId),
        date: Value(entry.date),
        createdAt: Value(entry.createdAt),

        // Updateable fields: use new value if provided, otherwise keep existing
        content: content != null ? Value(content) : Value(entry.content),
        isCompleted: isCompleted != null
            ? Value(isCompleted)
            : Value(entry.isCompleted),
        mood: mood != null ? Value(mood) : Value(entry.mood),
        tags: tags != null ? Value(_encodeTags(tags)) : Value(entry.tags),

        // Always update the timestamp and sync status
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
        pendingOperation: const Value('UPDATE'),
      );

      await _db.updateJournalEntry(companion);
      _logger.t("Update successful for entry ID: ${entry.id}");
    } catch (e, stack) {
      _logger.e("Error in updateEntry", error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<JournalEntry> saveEntry({
    required int habitId,
    required String content,
    required DateTime date,
    bool isCompleted = false,
    int? mood,
    List<String>? tags,
  }) async {
    try {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _logger.d(
        "SaveEntry (Upsert) triggered for habit: $habitId on $normalizedDate",
      );

      final existing = await _db.getJournalEntryForDate(
        habitId,
        normalizedDate,
      );

      if (existing == null) {
        _logger.d("No existing entry found, redirecting to createEntry");
        return await createEntry(
          habitId: habitId,
          content: content,
          date: normalizedDate,
          isCompleted: isCompleted,
          mood: mood,
          tags: tags,
        );
      } else {
        _logger.d(
          "Existing entry found (ID: ${existing.id}), redirecting to updateEntry",
        );
        await updateEntry(
          entry: existing,
          content: content,
          isCompleted: isCompleted,
          mood: mood,
          tags: tags,
        );
        return (await _db.getJournalEntryForDate(habitId, normalizedDate))!;
      }
    } catch (e, stack) {
      _logger.e("Error in saveEntry (upsert)", error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      _logger.w("Deleting journal entry ID: $id");
      await _db.deleteJournalEntry(id);
    } catch (e, stack) {
      _logger.e(
        "Error deleting journal entry ID: $id",
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _encodeTags(List<String> tags) => '["${tags.join('","')}"]';

  List<String> decodeTags(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      final stripped = json.replaceAll(RegExp(r'[\[\]"]'), '');
      return stripped.split(',').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      _logger.w("Failed to decode tags: $json");
      return [];
    }
  }
}
