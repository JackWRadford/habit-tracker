import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

/// View Model for analytics view
class AnalyticsModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Get total times done for the given [habit]
  Future<int> getTimesDone(Habit habit) async {
    int count = 0;
    count = await _api.allHabitDaysCountForHabit(habit.id!);
    return count;
  }

  /// Get the total times missed for the given [habit]
  ///
  /// Calculates the times required from the first done
  /// If not habitDays yet, return 0
  Future<int> getTimesMissed(Habit habit) async {
    int count = 0;
    int timesRequired = 0;
    int timesDone = await getTimesDone(habit);
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    DateTime? oldest = await _api.oldestDateOfHabitDay(habit.id!);
    if (oldest != null) {
      // Calculate days required since 'oldest' date
      while (oldest!.isBefore(now)) {
        // Check if the weekday is in the habit's requiredDays
        if (habit.requiredDays[oldest.weekday - 1]) {
          timesRequired++;
        }
        // Iterate oldest forward by one
        oldest = DateTime(oldest.year, oldest.month, oldest.day + 1);
      }
      count = timesRequired - timesDone;
      // Set to 0 if done more times than required
      if (count < 0) count = 0;
    }
    return count;
  }

  /// Calculate current streak for given [habit]
  ///
  /// Streak is only broken if a required day is missed
  /// HabitDays on non-required days still increment the streak
  /// Max streak of 99
  Future<int> getCurrentStreak(Habit habit) async {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    int streak = 0;
    for (var i = 0; i < 100; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      if (await _api.isDayForHabit(habit.id!, day)) {
        streak++;
      } else {
        if ((habit.requiredDays[day.weekday - 1]) && i > 0) break;
      }
    }
    return streak;
  }

  /// Get highest streak
  Future<int> getHighestStreak(Habit habit) async {
    return 0;
  }
}
