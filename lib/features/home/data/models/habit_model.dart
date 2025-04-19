import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodletracker/features/home/domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  HabitModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.completedDates,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'completedDates': completedDates.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    List<DateTime> dates = [];
    if (map['completedDates'] != null) {
      dates = (map['completedDates'] as List).map((timestamp) {
        if (timestamp is Timestamp) {
          return timestamp.toDate();
        }
        return DateTime.now(); // Fallback
      }).toList();
    }

    return HabitModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
      completedDates: dates,
    );
  }

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      userId: entity.userId,
      completedDates: entity.completedDates,
    );
  }
}