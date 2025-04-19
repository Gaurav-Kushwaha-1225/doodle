import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class MarkHabitCompletedUseCase {
  final HabitRepository repository;

  MarkHabitCompletedUseCase(this.repository);

  Future<void> call(String habitId, DateTime date) async {
    return await repository.markHabitAsCompleted(habitId, date);
  }
}