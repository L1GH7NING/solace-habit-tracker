import 'package:drift/drift.dart' show Value, ComparableExpr, BooleanExpressionOperators;
import 'package:zenith_habit_tracker/data/local/app_database.dart';


class HabitService {
  final AppDatabase _db;

  // The service depends on the database.
  HabitService(this._db);

  // Stream methods to be used by the UI
  Stream<List<Habit>> watchHabits(String userId) => _db.watchHabits(userId);

  Stream<List<HabitCompletion>> watchCompletionsForDate(
    String userId,
    DateTime date,
  ) => _db.watchCompletionsForDate(userId, date);

  // Method for logging a completion.
  // The UI doesn't need to know about `HabitCompletionsCompanion`.
  Future<void> logCompletion({
    required int habitId,
    required String userId,
    required double value,
  }) async {
    final completion = HabitCompletionsCompanion(
      habitId: Value(habitId),
      userId: Value(userId),
      completedAt: Value(DateTime.now()),
      value: Value(value),
      updatedAt: Value(DateTime.now()),
    );
    await _db.insertCompletion(completion);
  }

  /// Deletes all completions for a specific habit on a given date.
  Future<void> deleteCompletionsForDay({
    required int habitId,
    required String userId,
    required DateTime date,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    // Create a delete statement that targets all completions for the given habit and date range.
    final deleteStatement = _db.delete(_db.habitCompletions)
      ..where(
        (c) =>
            c.habitId.equals(habitId) &
            c.userId.equals(userId) &
            c.completedAt.isBiggerOrEqualValue(start) &
            c.completedAt.isSmallerThanValue(end),
      );

    // Execute the delete operation.
    await deleteStatement.go();
  }

  Future<void> logCompletionForDate({
    required int habitId,
    required String userId,
    required double value,
    required DateTime date,
  }) async {
    await _db.insertCompletion(
      HabitCompletionsCompanion.insert(
        habitId: habitId,
        userId: userId,
        value: Value(value),
        completedAt: DateTime(
          date.year,
          date.month,
          date.day,
          DateTime.now().hour,
          DateTime.now().minute,
        ),
        updatedAt: DateTime.now(),
      ),
    );
  }
}