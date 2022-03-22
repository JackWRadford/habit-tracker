class HabitDay {
  int? id;
  late int habitId;
  late DateTime date;

  /// Not saved in database (true if from database)
  late bool isDone;

  HabitDay({required this.habitId, required this.date, required this.isDone});

  /// Convert from HabitDay to Map
  Map<String, dynamic> toMap() {
    return {'habitId': habitId, 'date': date.toIso8601String()};
  }

  /// Convert from Map to HabitDay
  HabitDay.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    habitId = map['habitId'];
    date = DateTime.parse(map['date']);
    isDone = true; // True if from database
  }
}
