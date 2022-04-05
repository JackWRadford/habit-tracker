import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/settings.dart';
import 'package:habit_tracker/core/services/database_api.dart';

/// Local database API
final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

/// Current settings state
Settings _settings = Settings();

Future<void> initSettings() async {
  _settings = await _api.getSettings();
}

class SettingsService {
  VoidCallback? callBackSettingsModel;

  /// Constructor
  SettingsService({this.callBackSettingsModel});

  /// Gets settings from the DB
  getSettings() {
    return _settings;
  }

  /// Update settings with (this) settings
  Future<void> updateSettings() async {
    await _api.updateSettings(_settings);
    // Call callback to update settingsModel
    if (callBackSettingsModel != null) callBackSettingsModel!();
  }
}
