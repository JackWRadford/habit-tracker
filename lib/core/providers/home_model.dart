import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/services/notification_service.dart';

class HomeModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Notification service
  final NotificationService _notificationService =
      locator<NotificationService>();

  /// Currently selected habit, used in [addNewHabit] to set the pos
  Habit selectedHabit = Habit();

  /// List of allHabits (since last [getAllHabits] call)
  List<Habit> _habits = [];

  /// Set selected habit
  void setSelectedHabit(Habit habit) {
    selectedHabit = habit;
  }

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    _habits = await _api.getAllHabits();
    return _habits;
  }

  /// Get habits count
  Future<int> getHabitsCount() async {
    return await _api.getHabitsCount();
  }

  /// Add new habit
  Future<int> addNewHabit(Habit h) async {
    // Set pos of new habit to top of list
    h.pos = _habits.length;
    int id = await _api.insertHabit(h);
    notifyListeners();
    return id;
  }

  /// Update given habit [h] ALSO UPDATES SELECTEDHABIT
  Future<void> updateHabit(Habit h) async {
    // Update selectedHabit to reflect changes in habitView
    selectedHabit = h;
    // Update habit in database
    await _api.updateHabit(h);
    notifyListeners();
  }

  /// Update list of [habits]' pos with their index in the given list
  Future<void> updateHabits(List<Habit> habits) async {
    for (var i = 0; i < habits.length; i++) {
      habits[i].pos = i;
      await _api.updateHabit(habits[i]);
    }
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
    // Cancel it's notifications
    _notificationService.cancelNotificationWithId(id);
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
