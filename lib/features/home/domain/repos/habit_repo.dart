import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';

abstract class HabitRepository {
  Future<List<HabitEntity>> getHabits(String userId);
  Future<void> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(String habitId);
  Future<void> markHabitAsCompleted(String habitId, DateTime date);
}