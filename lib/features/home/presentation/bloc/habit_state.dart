part of 'habit_bloc.dart';

abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitsLoaded extends HabitState {
  final List<HabitEntity> habits;

  HabitsLoaded({required this.habits});
}

class HabitError extends HabitState {
  final String message;

  HabitError({required this.message});
}

class HabitAdded extends HabitState {}

class HabitDeleted extends HabitState {}

class HabitCompleted extends HabitState {}