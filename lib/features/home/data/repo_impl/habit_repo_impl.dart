import 'package:doodletracker/features/home/data/data_sources/habit_data_sources_impl.dart';
import 'package:doodletracker/features/home/data/models/habit_model.dart';
import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';
import 'package:doodletracker/features/home/domain/repos/habit_repo.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSourceImpl remoteDataSource;

  HabitRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HabitEntity>> getHabits(String userId) async {
    return await remoteDataSource.getHabits(userId);
  }

  @override
  Future<void> addHabit(HabitEntity habit) async {
    await remoteDataSource.addHabit(HabitModel.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await remoteDataSource.updateHabit(HabitModel.fromEntity(habit));
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await remoteDataSource.deleteHabit(habitId);
  }

  @override
  Future<void> markHabitAsCompleted(String habitId, DateTime date) async {
    await remoteDataSource.markHabitAsCompleted(habitId, date);
  }
}