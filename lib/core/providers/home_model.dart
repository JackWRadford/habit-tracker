import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

class HomeModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Currently selected habit (used to update habitView when habit is edited)
  Habit selectedHabit = Habit();

  /// Set selected habit
  void setSelectedHabit(Habit habit) {
    selectedHabit = habit;
  }

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    return await _api.getAllHabits();
  }

  /// Get habits count
  Future<int> getHabitsCount() async {
    return await _api.getHabitsCount();
  }

  /// Add new habit
  Future<void> addNewHabit(Habit h) async {
    await _api.insertHabit(h);
    notifyListeners();
  }

  /// Update given habit [h]
  Future<void> updateHabit(Habit h) async {
    // Update selectedHabit to reflect changes in habitView
    selectedHabit = h;
    // Update habit in database
    await _api.updateHabit(h);
    notifyListeners();
  }

  /// Update given habit day (delete row if settings as not done)
  Future<void> updateHabitDay(HabitDay habitDay) async {
    if (habitDay.isDone) {
      await _api.insertHabitDay(habitDay);
    } else {
      await _api.deleteHabitDay(habitDay.id!);
    }
    notifyListeners();
  }

  /// Delete habit from given id
  Future<void> deleteHabit(int id) async {
    await _api.deleteHabit(id);
    notifyListeners();
  }

  /// Reset habit data
  Future<void> resetHabitData(Habit h) async {
    // Reset habit best streak
    h.bestStreak = 0;
    await _api.updateHabit(h);
    // Delete all habitDays for given habitId
    await _api.deleteHabitDaysForHabit(h.id!);
    notifyListeners();
  }

  /// Return integer corresponding to message required
  int getWelcome() {
    int h = DateTime.now().hour;
    if ((h > 4) && (h < 12)) {
      return 0;
    } else if ((h >= 12) && (h < 17)) {
      return 1;
    } else {
      return 2;
    }
  }

  /// Return dates of last 7 days
  List<DateTime> getLastWeek() {
    // Get date without time
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    List<DateTime> result = [];
    for (var i = 0; i < 7; i++) {
      result.add(now);
      // Decrement now by one day
      now = DateTime(now.year, now.month, now.day - 1);
    }
    return result;
  }
}
