import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/chart_period.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

class Habit {
  int? id;
  String title = '';
  Color color = myRed;
  List<bool> requiredDays = [false, false, false, false, false, false, false];
  int bestStreak = 0;
  int pos = 0;
  ChartPeriod chartPeriod = ChartPeriod.year;
  DateTime notiTime = DateTime(2022, 3, 1, 12, 0); // Only time is used
  bool notiToggle = false;
  String notiBody = '';
  String notes = '';

  /// List of last 7 habitDays
  List<HabitDay> lastWeek = [];

  /// Double for last 5 weeks (percentage complete)
  double last30 = 0;

  Habit();

  /// Convert from Habit to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': _colorToInt(color),
      'mon': (requiredDays[0]) ? 1 : 0,
      'tue': (requiredDays[1]) ? 1 : 0,
      'wed': (requiredDays[2]) ? 1 : 0,
      'thu': (requiredDays[3]) ? 1 : 0,
      'fri': (requiredDays[4]) ? 1 : 0,
      'sat': (requiredDays[5]) ? 1 : 0,
      'sun': (requiredDays[6]) ? 1 : 0,
      'bestStreak': bestStreak,
      'pos': pos,
      'chartPeriod': chartPeriod.index,
      'notiTime': notiTime.toIso8601String(),
      'notiToggle': (notiToggle) ? 1 : 0,
      'notiBody': notiBody,
      'notes': notes,
    };
  }

  /// Convert from Map to Habit
  Habit.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    color = _intToColor(map['color']);
    requiredDays[0] = (map['mon'] == 1);
    requiredDays[1] = (map['tue'] == 1);
    requiredDays[2] = (map['wed'] == 1);
    requiredDays[3] = (map['thu'] == 1);
    requiredDays[4] = (map['fri'] == 1);
    requiredDays[5] = (map['sat'] == 1);
    requiredDays[6] = (map['sun'] == 1);
    bestStreak = map['bestStreak'];
    pos = (map['pos'] != null) ? map['pos'] : 0;
    chartPeriod = (map['chartPeriod'] != null)
        ? ChartPeriod.values[map['chartPeriod']]
        : ChartPeriod.year;
    notiTime = (map['notiTime'] != null)
        ? DateTime.parse(map['notiTime'])
        : DateTime(2022, 3, 1, 12, 0);
    notiToggle = (map['notiToggle'] == 1);
    notiBody = (map['notiBody'] != null) ? map['notiBody'] : '';
    notes = (map['notes'] != null) ? map['notes'] : '';
  }

  /// Convert from color [c] to int
  int _colorToInt(Color c) {
    if (c == myRed) return 0;
    if (c == myOrange) return 1;
    if (c == myYellow) return 2;
    if (c == myGreen) return 3;
    if (c == myBlue) return 4;
    if (c == myIndigo) return 5;
    return 0;
  }

  /// Convert from int [i] to color
  Color _intToColor(int i) {
    switch (i) {
      case 0:
        return myRed;
      case 1:
        return myOrange;
      case 2:
        return myYellow;
      case 3:
        return myGreen;
      case 4:
        return myBlue;
      case 5:
        return myIndigo;
      default:
        return myRed;
    }
  }
}
