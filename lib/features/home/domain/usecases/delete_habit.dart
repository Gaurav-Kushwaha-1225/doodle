import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;

  DeleteHabitUseCase(this.repository);

  Future<void> call(String habitId) async {
    return await repository.deleteHabit(habitId);
  }
}