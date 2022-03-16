import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

class Habit {
  int? id;
  String title = '';
  Color color = myRed;
  List<bool> requiredDays = [false, false, false, false, false, false, false];

  /// List of last 7 habitDays
  List<HabitDay> lastWeek = [];

  /// Double for last 30 days percentage completed
  double last30 = 0;

  Habit({
    this.title = '',
    this.color = myRed,
    this.requiredDays = const [false, false, false, false, false, false, false],
  });

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
