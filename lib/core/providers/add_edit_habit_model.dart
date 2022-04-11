import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/notification_service.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

final DateTime _defaultTime = DateTime(2022, 3, 1, 12, 0);

/// Logic regarding creating or editing a habit
class AddEditHabitModel extends BaseModel {
  /// Notification service
  final NotificationService _notificationService =
      locator<NotificationService>();

  /// Time selected for notification
  DateTime selectedTime = _defaultTime;

  /// Current Time while scrolling
  DateTime currentTime = _defaultTime;

  bool notiToggle = false;

  /// Notification body text
  String notiBody = '';

  /// Color currently selected
  Color selectedColor = myRed;

  /// Repeat on days selected
  List<bool> selectedDays = [true, true, true, true, true, true, true];

  /// Set day at given [index] with the opposite of its current value
  void setSelectedDay(int index) {
    selectedDays[index] = !selectedDays[index];
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
    selectedTime = _defaultTime;
    currentTime = _defaultTime;
    notiToggle = false;
  }

  /// Set selected time to current time
  void setSelecteTime() {
    selectedTime = currentTime;
    notifyListeners();
  }

  /// Set notification toggle
  void setNotiToggle(bool value) {
    notiToggle = value;
    notifyListeners();
  }

  /// Reset selected time
  void resetSelectedTime() {
    selectedTime = DateTime(2022, 3, 1, 12, 0);
  }

  /// Update notifications for [habit]
  Future<void> updateNotifications(Habit habit) async {
    _notificationService.scheduleHabitNoti(habit);
  }
}
