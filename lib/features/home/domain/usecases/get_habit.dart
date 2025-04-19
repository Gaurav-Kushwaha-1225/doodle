import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';
import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<List<HabitEntity>> call(String userId) async {
    return await repository.getHabits(userId);
  }
}