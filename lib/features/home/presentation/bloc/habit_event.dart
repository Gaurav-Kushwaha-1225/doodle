part of 'habit_bloc.dart';

abstract class HabitEvent {}

class GetHabitsEvent extends HabitEvent {
  final String userId;

  GetHabitsEvent({required this.userId});
}

class AddHabitEvent extends HabitEvent {
  final String name;
  final String userId;

  AddHabitEvent({required this.name, required this.userId});
}

class MarkHabitCompletedEvent extends HabitEvent {
  final String habitId;
  final String userId;

  MarkHabitCompletedEvent({required this.habitId, required this.userId});
}

class DeleteHabitEvent extends HabitEvent {
  final String habitId;
  final String userId;

  DeleteHabitEvent({required this.habitId, required this.userId});
}
