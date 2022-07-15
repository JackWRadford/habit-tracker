import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/notification_service.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:habit_tracker/core/services/review_service.dart';

/// For settings view
class SettingsModel extends BaseModel {
  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();

  /// Review service
  final ReviewService _reviewService = locator<ReviewService>();

  /// Notification service
  final NotificationService _notificationService =
      locator<NotificationService>();

  /// Constructor
  SettingsModel() {
    // Callback from settingsService when settings are updated (purchased pro)
    _settingsService.callBackSettingsModel = () => notifyListeners();
  }

  bool getDisableAllNoti() {
    return _settingsService.getSettings().disableAllNoti;
  }

  /// Sets new disableAllNoti (updates DB)
  setDisableAllNoti(bool value, BuildContext ctx) async {
    // Update local settings disableAllNoti
    _settingsService.getSettings().disableAllNoti = value;
    // Update settings in database
    await _settingsService.updateSettings();
    // Update notifications
    await _notificationService.disableAllNoti(value, ctx);

    notifyListeners();
  }

  /// Open app store review page
  void openReviewInStore() {
    _reviewService.openReviewInStore();
  }

  /// Get if user has PRO
  bool isUserPro() {
    return _settingsService.getSettings().isPro;
  }
}
