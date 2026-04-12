import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ──────────────────────────────────────────────────────────────────

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()(); // null until synced
  TextColumn get userId => text()(); // firebase_uid or 'guest'
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get color => integer()(); // store as ARGB int
  TextColumn get icon => text()(); // emoji or icon name
  TextColumn get frequencyType =>
      text() // 'DAILY','WEEKLY','MONTHLY'
          .withDefault(const Constant('DAILY'))();
  TextColumn get frequencyDays =>
      text().nullable()(); // JSON e.g. '["MON","WED"]'
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get habitTime => integer().nullable()();
  IntColumn get reminderTime => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation =>
      text().nullable()(); // 'CREATE','UPDATE','DELETE'
}

class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  IntColumn get habitId => integer().references(Habits, #id)();
  TextColumn get userId => text()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get count => integer().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation => text().nullable()();
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Habits, HabitCompletions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(
          habits,
          habits.habitTime as GeneratedColumn<Object>,
        );
        await migrator.addColumn(
          habits,
          habits.reminderTime as GeneratedColumn<Object>,
        );
      }
    },
  );

  // ── Habits ────────────────────────────────────────────────────────────────

  // Watch all non-archived habits for a user (reactive stream)
  Stream<List<Habit>> watchHabits(String userId) =>
      (select(habits)
            ..where((h) => h.userId.equals(userId) & h.isArchived.equals(false))
            ..orderBy([(h) => OrderingTerm.asc(h.startDate)]))
          .watch();

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

  Future<int> insertCompletion(HabitCompletionsCompanion completion) =>
      into(habitCompletions).insert(completion);

  // ── Sync helpers ──────────────────────────────────────────────────────────

  // Fetch everything that hasn't been synced yet
  Future<List<Habit>> getUnsyncedHabits() =>
      (select(habits)..where((h) => h.isSynced.equals(false))).get();

  Future<List<HabitCompletion>> getUnsyncedCompletions() =>
      (select(habitCompletions)..where((c) => c.isSynced.equals(false))).get();

  // Mark a habit as synced and store the server-assigned ID
  Future<void> markHabitSynced(int localId, String serverId) =>
      (update(habits)..where((h) => h.id.equals(localId))).write(
        HabitsCompanion(
          serverId: Value(serverId),
          isSynced: const Value(true),
          pendingOperation: const Value(null),
        ),
      );
}

// ── Connection ───────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'solace.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
