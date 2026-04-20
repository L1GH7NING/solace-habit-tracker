import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ──────────────────────────────────────────────────────────────────

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get color => integer()();
  TextColumn get icon => text()();
  TextColumn get frequencyType => text().withDefault(const Constant('DAILY'))();
  TextColumn get frequencyDays => text().nullable()();
  RealColumn get targetValue => real().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant('times'))();
  TextColumn get type => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get habitTime => integer().nullable()();
  IntColumn get reminderTime => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation => text().nullable()();
}

class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  IntColumn get habitId => integer().references(Habits, #id)();
  TextColumn get userId => text()();
  DateTimeColumn get completedAt => dateTime()();
  RealColumn get value => real().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation => text().nullable()();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()(); // null until synced
  IntColumn get habitId => integer().references(Habits, #id)();
  TextColumn get userId => text()();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()(); // the day this entry belongs to
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))(); // was habit done that day
  IntColumn get mood => integer().nullable()(); // optional 1–5 mood score
  TextColumn get tags => text().nullable()(); // JSON e.g. '["focus","sleep"]'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation => text().nullable()();
}

class HabitTargetHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  RealColumn get targetValue => real()();
  TextColumn get unit => text()();
  DateTimeColumn get effectiveFrom => dateTime()();
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [Habits, HabitCompletions, JournalEntries, HabitTargetHistory],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 3) {
        await migrator.addColumn(
          habits,
          habits.targetValue as GeneratedColumn<Object>,
        );
        await migrator.addColumn(
          habits,
          habits.unit as GeneratedColumn<Object>,
        );
        await migrator.addColumn(
          habitCompletions,
          habitCompletions.value as GeneratedColumn<Object>,
        );
        await customStatement('UPDATE habits SET target_value = target_count');
        await customStatement('UPDATE habit_completions SET value = count');
      }
      if (from < 4) {
        await migrator.createTable(journalEntries);
      }
      if (from < 5) {
        await migrator.createTable(habitTargetHistory);
        await customStatement('''
          INSERT INTO habit_target_history (habit_id, target_value, unit, effective_from)
          SELECT id, target_value, unit, start_date FROM habits
        ''');
      }
    },
  );

  // ── Habits ────────────────────────────────────────────────────────────────

  Stream<List<Habit>> watchHabits(String userId) =>
      (select(habits)
            ..where((h) => h.userId.equals(userId) & h.isArchived.equals(false))
            ..orderBy([(h) => OrderingTerm.asc(h.startDate)]))
          .watch();

  Future<Habit?> getHabitById(int id) =>
      (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();

  Future<int> insertHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Future<bool> updateHabit(HabitsCompanion habit) =>
      update(habits).replace(habit);

  Future<int> archiveHabit(int id) =>
      (update(habits)..where((h) => h.id.equals(id))).write(
        HabitsCompanion(
          isArchived: const Value(true),
          isSynced: const Value(false),
          pendingOperation: const Value('DELETE'),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ── Completions ───────────────────────────────────────────────────────────

  Stream<List<HabitCompletion>> watchCompletionsForDate(
    String userId,
    DateTime date,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(habitCompletions)..where(
          (c) =>
              c.userId.equals(userId) &
              c.completedAt.isBiggerOrEqualValue(start) &
              c.completedAt.isSmallerThanValue(end),
        ))
        .watch();
  }

  bool isCompleted(double progress, double target) => progress >= target;

  Future<int> insertCompletion(HabitCompletionsCompanion completion) =>
      into(habitCompletions).insert(completion);

  // ── Journal ───────────────────────────────────────────────────────────────

  /// Watch all journal entries for a habit, newest first.
  Stream<List<JournalEntry>> watchJournalEntries(int habitId) =>
      (select(journalEntries)
            ..where((j) => j.habitId.equals(habitId))
            ..orderBy([(j) => OrderingTerm.desc(j.date)]))
          .watch();

  /// Watch the single entry for a habit on a specific calendar day.
  Stream<JournalEntry?> watchJournalEntryForDate(int habitId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(journalEntries)
          ..where(
            (j) =>
                j.habitId.equals(habitId) &
                j.date.isBiggerOrEqualValue(start) &
                j.date.isSmallerThanValue(end),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<JournalEntry?> getJournalEntryForDate(int habitId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(journalEntries)
          ..where(
            (j) =>
                j.habitId.equals(habitId) &
                j.date.isBiggerOrEqualValue(start) &
                j.date.isSmallerThanValue(end),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertJournalEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<bool> updateJournalEntry(JournalEntriesCompanion entry) =>
      update(journalEntries).replace(entry);

  Future<int> deleteJournalEntry(int id) =>
      (delete(journalEntries)..where((j) => j.id.equals(id))).go();

  // ── Sync helpers ──────────────────────────────────────────────────────────

  Future<List<Habit>> getUnsyncedHabits() =>
      (select(habits)..where((h) => h.isSynced.equals(false))).get();

  Future<List<HabitCompletion>> getUnsyncedCompletions() =>
      (select(habitCompletions)..where((c) => c.isSynced.equals(false))).get();

  Future<List<JournalEntry>> getUnsyncedJournalEntries() =>
      (select(journalEntries)..where((j) => j.isSynced.equals(false))).get();

  Future<void> markHabitSynced(int localId, String serverId) =>
      (update(habits)..where((h) => h.id.equals(localId))).write(
        HabitsCompanion(
          serverId: Value(serverId),
          isSynced: const Value(true),
          pendingOperation: const Value(null),
        ),
      );

  Future<void> markJournalEntrySynced(int localId, String serverId) =>
      (update(journalEntries)..where((j) => j.id.equals(localId))).write(
        JournalEntriesCompanion(
          serverId: Value(serverId),
          isSynced: const Value(true),
          pendingOperation: const Value(null),
        ),
      );

  // ── Target History ────────────────────────────────────────────────────────

  Future<void> upsertTargetHistory(HabitTargetHistoryCompanion entry) async {
    final today = DateTime(
      entry.effectiveFrom.value.year,
      entry.effectiveFrom.value.month,
      entry.effectiveFrom.value.day,
    );
    final tomorrow = today.add(const Duration(days: 1));

    // Check if a row already exists for this habit on this date
    final existing =
        await (select(habitTargetHistory)..where(
              (h) =>
                  h.habitId.equals(entry.habitId.value) &
                  h.effectiveFrom.isBiggerOrEqualValue(today) &
                  h.effectiveFrom.isSmallerThanValue(tomorrow),
            ))
            .getSingleOrNull();

    if (existing != null) {
      // Update the existing row instead of inserting a new one
      await (update(
        habitTargetHistory,
      )..where((h) => h.id.equals(existing.id))).write(
        HabitTargetHistoryCompanion(
          targetValue: entry.targetValue,
          unit: entry.unit,
        ),
      );
    } else {
      await into(habitTargetHistory).insert(entry);
    }
  }

  Future<List<HabitTargetHistoryData>> getTargetHistory(int habitId) =>
      (select(habitTargetHistory)
            ..where((h) => h.habitId.equals(habitId))
            ..orderBy([(h) => OrderingTerm.asc(h.effectiveFrom)]))
          .get();

  Future<List<HabitTargetHistoryData>> getTargetHistoryForUser(
    String userId,
  ) async {
    final userHabits = await (select(
      habits,
    )..where((h) => h.userId.equals(userId))).get();
    final ids = userHabits.map((h) => h.id).toList();
    return (select(
      habitTargetHistory,
    )..where((h) => h.habitId.isIn(ids))).get();
  }

  Future<void> insertTargetHistory(HabitTargetHistoryCompanion entry) =>
      into(habitTargetHistory).insert(entry);

  Stream<List<HabitTargetHistoryData>> watchTargetHistory(int habitId) =>
      (select(habitTargetHistory)
            ..where((h) => h.habitId.equals(habitId))
            ..orderBy([(h) => OrderingTerm.asc(h.effectiveFrom)]))
          .watch();

  Stream<List<HabitTargetHistoryData>> watchTargetHistoryForUser(
    String userId,
  ) async* {
    final userHabits = await (select(
      habits,
    )..where((h) => h.userId.equals(userId))).get();
    final ids = userHabits.map((h) => h.id).toList();
    yield* (select(
      habitTargetHistory,
    )..where((h) => h.habitId.isIn(ids))).watch();
  }
}

// ── Connection ───────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'solace.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
