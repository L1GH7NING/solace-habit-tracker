import '../../../data/local/app_database.dart';

class HabitService {
  final AppDatabase db;

  HabitService(this.db);

  Stream<List<Habit>> watchHabits(String userId) {
    return db.watchHabits(userId);
  }

  Future<void> logCompletion(Habit habit, String userId) async {
    await db.insertCompletion(
      HabitCompletionsCompanion.insert(
        habitId: habit.id,
        userId: userId,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}