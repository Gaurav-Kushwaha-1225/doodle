import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';
import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class AddHabitUseCase {
  final HabitRepository repository;

  AddHabitUseCase(this.repository);

  Future<void> call(HabitEntity habit) async {
    return await repository.addHabit(habit);
  }
}