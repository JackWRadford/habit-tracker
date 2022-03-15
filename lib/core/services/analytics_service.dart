// import 'package:habit_tracker/core/locator.dart';
// import 'package:habit_tracker/core/models/habit.dart';
// import 'package:habit_tracker/core/services/database_api.dart';

/// Logic regarding calculating of habit analytics
class AnalyticsService {
  /// Local database API
  // final LocalDatabaseApi _api = locator<LocalDatabaseApi>();
  // TODO calculate number of required days in last n base on days of week selected
  // /// Calculate % of days the [habit] was completed in the last [n] days
  // Future<double> calcPercentageLastN(Habit habit, int n) async {
  //   // Calculate date of earliest habitDay required
  //   DateTime date = DateTime.now();
  //   date = DateTime(date.year, date.month, date.day - n);

  //   // Get number of habitDays (days completed) since [date]
  //   int doneCount = await _api.habitDaysCountForHabit(habit.id!, date);
  //   return 0;
  // }
}
