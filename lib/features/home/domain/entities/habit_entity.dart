class HabitEntity {
  final String id;
  final String name;
  final String userId;
  final List<DateTime> completedDates;

  HabitEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.completedDates,
  });

  bool isCompletedToday() {
    final today = DateTime.now();
    final todayWithoutTime = DateTime(today.year, today.month, today.day);
    
    return completedDates.any((date) {
      final dateWithoutTime = DateTime(date.year, date.month, date.day);
      return dateWithoutTime.isAtSameMomentAs(todayWithoutTime);
    });
  }

  int getStreak() {
    if (completedDates.isEmpty) return 0;

    final today = DateTime.now();
    int streak = 0;
    
    // Sort dates to ensure we check in chronological order
    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a)); // Descending

    // For the last 7 days, check if each day exists in completedDates
    for (int i = 0; i < 7; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final checkDateWithoutTime = DateTime(
        checkDate.year, 
        checkDate.month, 
        checkDate.day,
      );
      
      bool completed = sortedDates.any((date) {
        final dateWithoutTime = DateTime(date.year, date.month, date.day);
        return dateWithoutTime.isAtSameMomentAs(checkDateWithoutTime);
      });
      
      if (completed) {
        streak++;
      } else {
        break; // Break at first missed day
      }
    }
    
    return streak;
  }
}