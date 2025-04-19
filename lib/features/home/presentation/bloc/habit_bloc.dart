import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';
import 'package:doodletracker/features/home/domain/usecases/add_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/delete_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/get_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/mark_habit_done.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'habit_state.dart';
part 'habit_event.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabitsUseCase getHabitsUseCase;
  final AddHabitUseCase addHabitUseCase;
  final MarkHabitCompletedUseCase markHabitCompletedUseCase;
  final DeleteHabitUseCase deleteHabitUseCase;

  HabitBloc({
    required this.getHabitsUseCase,
    required this.addHabitUseCase,
    required this.markHabitCompletedUseCase,
    required this.deleteHabitUseCase,
  }) : super(HabitInitial()) {
    on<GetHabitsEvent>(_onGetHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<MarkHabitCompletedEvent>(_onMarkHabitCompleted);
    on<DeleteHabitEvent>(_onDeleteHabit);
  }

  Future<void> _onGetHabits(
    GetHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());
    try {
      final habits = await getHabitsUseCase(event.userId);
      emit(HabitsLoaded(habits: habits));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  Future<void> _onAddHabit(
    AddHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());
    try {
      final habit = HabitEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID, will be replaced by Firestore
        name: event.name,
        userId: event.userId,
        completedDates: [],
      );
      
      await addHabitUseCase(habit);
      emit(HabitAdded());
      
      // Refresh the habits list
      add(GetHabitsEvent(userId: event.userId));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  Future<void> _onMarkHabitCompleted(
    MarkHabitCompletedEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());
    try {
      await markHabitCompletedUseCase(event.habitId, DateTime.now());
      emit(HabitCompleted());
      
      add(GetHabitsEvent(userId: event.userId));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());
    try {
      await deleteHabitUseCase(event.habitId);
      emit(HabitDeleted());
      
      add(GetHabitsEvent(userId: event.userId));
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }
}