import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/chart_period.dart';
import 'package:habit_tracker/core/helper/helper_functions.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/models/heat_col.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

// /// Data for screenshots
// final List<dynamic> _testChartYear = [
//   [
//     FlSpot(11, 75),
//     FlSpot(10, 60),
//     FlSpot(9, 65),
//     FlSpot(8, 40),
//     FlSpot(7, 45),
//     FlSpot(6, 50),
//     FlSpot(5, 70),
//     FlSpot(4, 60),
//     FlSpot(3, 35),
//     FlSpot(2, 20),
//     FlSpot(1, 25),
//     FlSpot(0, 15)
//   ],
//   [5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4]
// ];

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
  /// If no habitDays yet, return 0
  Future<int> getTimesMissed(Habit habit) async {
    DateTime today = getToday();
    int count = 0;
    DateTime? oldest = await _api.oldestDateOfHabitDay(habit.id!);
    if (oldest != null) {
      int req = _getTimesRequiedBetween(habit, oldest, today);
      int done = (await getTimesDone(habit));
      // If done today, decrement done by one
      if (await _api.isDayForHabit(habit.id!, today)) {
        done--;
      }
      count = req - done;
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
    DateTime now = getToday();
    int streak = 0;
    int i = 0;
    while (true) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      if (await _api.isDayForHabit(habit.id!, day)) {
        streak++;
      } else {
        if ((habit.requiredDays[day.weekday - 1]) && i > 0) break;
      }
      i++;
    }
    // Check if better than best streak. Update habit bestStreak, if so
    if (streak > habit.bestStreak) {
      habit.bestStreak = streak;
      await _api.updateHabit(habit);
      notifyListeners(); // Update bestStreak section
    }
    return streak;
  }

  /// Get best streak for given habit
  Future<int> getBestStreak(Habit habit) async {
    Habit? h = await _api.getHabitForId(habit.id!);
    if (h != null) {
      return h.bestStreak;
    } else {
      return 0;
    }
  }

  /// Calculate times required for habit [h] between dates [f], [t]
  int _getTimesRequiedBetween(Habit h, DateTime f, DateTime t) {
    int timesRequired = 0;
    // Calculate days required between f and t
    while (f.isBefore(t)) {
      // Check if the weekday is in the habit's requiredDays
      if (h.requiredDays[f.weekday - 1]) {
        timesRequired++;
      }
      // Iterate oldest forward by one
      f = DateTime(f.year, f.month, f.day + 1);
    }
    return timesRequired;
  }

  /// Get last 12 months spot data and x-axis
  ///
  /// Returns lists of List<FlSpot> and List<String>
  Future<List<dynamic>> getChartData(Habit h) async {
    // Calculate % done of required between f and t for habit h [for ChartPeriod.year]
    Future<double> _getY(DateTime f, DateTime t) async {
      double value = (((await _api.habitDaysCountForHabit(h.id!, f, t)) /
              _getTimesRequiedBetween(h, f, t)) *
          100);
      // Cap value at 100(%)
      if (value > 100) value = 100;
      return value;
    }

    // Number of required days in last 5 weeks (based on weekdays selected)
    int requiredDays = 0;
    int numOfWeeks = 5;
    for (bool rDay in h.requiredDays) {
      if (rDay) requiredDays++;
    }
    requiredDays = requiredDays * numOfWeeks;

    // Calculate past 5 weeks percentage done from given day
    Future<double> _getRolling(DateTime d) async {
      if (requiredDays <= 0) return 100;
      // DateTime 5 weeks ago from d
      DateTime p = DateTime(d.year, d.month, d.day - (7 * numOfWeeks));
      int count = await _api.habitDaysCountForHabit(h.id!, p, d);
      double value = (count / requiredDays) * 100;
      if (value > 100) value = 100;
      return value;
    }

    List<FlSpot> spots = [];
    List<int> xAxis = [];
    DateTime today = getToday();

    // Get data depending on the habits chartPeriod
    switch (h.chartPeriod) {
      case ChartPeriod.year:
        // Current % done for each of last 12 months
        for (var i = 0; i < 12; i++) {
          DateTime f = DateTime(today.year, today.month - i, 1); // 1st of month
          DateTime t = DateTime(f.year, f.month + 1, 0); // last of month
          spots.add(FlSpot((11 - i).toDouble(), await _getY(f, t)));
          xAxis.add(f.month);
        }
        break;
      case ChartPeriod.month:
      case ChartPeriod.week:
        bool isMonth = (h.chartPeriod == ChartPeriod.month);
        int n = (isMonth) ? 30 : 7;
        // Iterator for month period spots x
        int j = 0;
        // Rolling percentage done in past x days (for past n days)
        // Ever-other day if month (every day for week)
        for (var i = 0; i < n; (isMonth) ? i += 2 : i++) {
          DateTime d =
              DateTime(today.year, today.month, today.day - i); // 1st of month
          spots.add(FlSpot(((isMonth) ? (14 - j) : (n - 1 - i)).toDouble(),
              await _getRolling(d)));
          xAxis.add(d.day);
          j++;
        }
        break;
      default:
    }

    return [spots, xAxis.reversed.toList()];
  }

  /// Generate initial chart data for future builder
  List<dynamic> getInitChartData() {
    List<FlSpot> spots = [];
    List<int> xAxis = [];
    DateTime today = getToday();
    for (var i = 0; i < 12; i++) {
      spots.add(FlSpot(i.toDouble(), 0));
      xAxis.add(today.month - i);
    }
    return [spots, xAxis];
  }

  /// Calculate list of HeatCol data for given habit [h]
  Future<List<HeatColData>> getHeatData(Habit h) async {
    List<HeatColData> heatData = [];
    DateTime now = getToday();
    // From this date (exclusive)
    DateTime from = DateTime(now.year - 1, now.month, now.day);
    List<HabitDay> days = await _api.getDaysFrom(h.id!, from);
    int currentMonth = now.month;
    bool newMonth = false;
    int monthLabel = 0;
    List<Color> currentCol = [];

    while (now.isAfter(from)) {
      HabitDay day = HabitDay(habitId: h.id!, date: now, isDone: false);
      // Check if days list includes day interator (now)
      if (days.map((d) => d.date).contains(now)) day.isDone = true;
      // Check if new month
      if (day.date.month != currentMonth) {
        monthLabel = currentMonth;
        currentMonth = day.date.month;
        newMonth = true;
      }
      if ((day.date.weekday == 7) && (currentCol.isNotEmpty)) {
        // Add week to list and start new week
        heatData.add(
          HeatColData(
            label: (newMonth) ? monthLabel : null,
            colors: currentCol,
          ),
        );
        newMonth = false;
        currentCol = [];
        currentCol.add(_getDayColor(h, day));
      } else {
        currentCol.add(_getDayColor(h, day));
      }
      now = DateTime(now.year, now.month, now.day - 1);
    }
    return heatData;
  }

  /// Get color for heatmap day for given [h] and [day]
  ///
  /// Used in [getHeatData] above
  Color _getDayColor(Habit h, HabitDay day) {
    if (day.isDone) {
      return h.color;
    } else if (h.requiredDays[day.date.weekday - 1]) {
      return h.color.withOpacity(0.2);
    } else {
      return Colors.transparent; // Shows color depending on theme in ui
    }
  }
}
