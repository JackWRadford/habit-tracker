import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

class Habit {
  int? id;
  String title = '';
  Color color = myRed;
  bool mon = false;
  bool tue = false;
  bool wed = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  bool sun = false;

  Habit({
    required this.title,
    required this.color,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  /// Convert from Habit to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': _colorToInt(color),
      'mon': (mon) ? 1 : 0,
      'tue': (tue) ? 1 : 0,
      'wed': (wed) ? 1 : 0,
      'thu': (thu) ? 1 : 0,
      'fri': (fri) ? 1 : 0,
      'sat': (sat) ? 1 : 0,
      'sun': (sun) ? 1 : 0,
    };
  }

  /// Convert from Map to Habit
  Habit.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    color = _intToColor(map['color']);
    mon = (map['mon'] == 1);
    tue = (map['tue'] == 1);
    wed = (map['wed'] == 1);
    thu = (map['thu'] == 1);
    fri = (map['fri'] == 1);
    sat = (map['sat'] == 1);
    sun = (map['sun'] == 1);
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
