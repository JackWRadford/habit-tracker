import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

/// Logic regarding creating or editing a habit
class AddEditHabitModel extends BaseModel {
  /// Color currently selected
  Color selectedColor = myRed;

  /// Repeat on days selected
  List<bool> selectedDays = [true, true, true, true, true, true, true];

  /// Set day at given [index] with [value]
  void setSelectedDay(int index, bool value) {
    selectedDays[index] = value;
    notifyListeners();
  }

  /// Set selected [color] and notify listeners
  void setSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  /// Reset selected values
  void resetSelected() {
    selectedColor = myRed;
    selectedDays = [true, true, true, true, true, true, true];
  }
}
