import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodletracker/features/home/data/models/habit_model.dart';

class HabitRemoteDataSourceImpl {
  final FirebaseFirestore _firestore;

  HabitRemoteDataSourceImpl(this._firestore);

  Future<List<HabitModel>> getHabits(String userId) async {
    final querySnapshot = await _firestore
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => HabitModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addHabit(HabitModel habit) async {
    final habitRef = _firestore.collection('habits').doc();
    
    // Update the ID with the Firestore-generated one
    final updatedHabit = HabitModel(
      id: habitRef.id,
      name: habit.name,
      userId: habit.userId,
      completedDates: habit.completedDates,
    );
    
    await habitRef.set(updatedHabit.toMap());
  }

  Future<void> updateHabit(HabitModel habit) async {
    await _firestore
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  Future<void> deleteHabit(String habitId) async {
    await _firestore.collection('habits').doc(habitId).delete();
  }

  Future<void> markHabitAsCompleted(String habitId, DateTime date) async {
    final docRef = _firestore.collection('habits').doc(habitId);
    
    // Get the current habit data
    final docSnapshot = await docRef.get();
    
    if (docSnapshot.exists) {
      final habitData = docSnapshot.data() as Map<String, dynamic>;
      final habit = HabitModel.fromMap(habitData);
      
      // Add today's date to completedDates if not already there
      final todayWithoutTime = DateTime(date.year, date.month, date.day);
      
      bool alreadyCompleted = habit.completedDates.any((completedDate) {
        final completedWithoutTime = DateTime(
          completedDate.year, 
          completedDate.month, 
          completedDate.day
        );
        return completedWithoutTime.isAtSameMomentAs(todayWithoutTime);
      });
      
      if (!alreadyCompleted) {
        final updatedDates = List<DateTime>.from(habit.completedDates)..add(date);
        
        final updatedHabit = HabitModel(
          id: habit.id,
          name: habit.name,
          userId: habit.userId,
          completedDates: updatedDates,
        );
        
        await docRef.update({
          'completedDates': updatedHabit.completedDates.map((d) => Timestamp.fromDate(d)).toList(),
        });
      }
    }
  }
}