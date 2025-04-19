import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';
import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class UpdateHabitUseCase {
  final HabitRepository repository;

  UpdateHabitUseCase(this.repository);

  Future<void> call(HabitEntity habit) async {
    return await repository.updateHabit(habit);
  }
}