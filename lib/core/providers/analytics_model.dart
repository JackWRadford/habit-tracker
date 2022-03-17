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

  /// Calculate % done for last [n] days

}
