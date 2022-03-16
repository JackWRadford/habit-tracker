import 'package:habit_tracker/core/models/habit.dart';

/// Args for add/ edit habit view
///
/// Takes a [habit] if editing, null if creating a new habit
class AddEditHabitArgs {
  final Habit? habit;

  AddEditHabitArgs({
    this.habit,
  });
}

/// Args for habit view
///
/// Takes a [habit]
class HabitArgs {
  final Habit habit;

  HabitArgs({
    required this.habit,
  });
}
