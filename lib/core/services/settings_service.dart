import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/settings.dart';
import 'package:habit_tracker/core/services/database_api.dart';

class SettingsService {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Current settings state
  Settings settings = Settings();

  /// Callback settingsModel when settings are updated (from IAPModel)
  VoidCallback? callBackSettingsModel;

  /// Callback localeModel when settings are updated
  VoidCallback? callBackLocaleModel;

  /// Constructor
  SettingsService({this.callBackSettingsModel, this.callBackLocaleModel});

  /// Gets settings from the DB
  Future<void> getSettings() async {
    settings = await _api.getSettings();
    // Call callback to update settingsModel
    if (callBackSettingsModel != null) callBackSettingsModel!();
    // Call callback to update localeModel
    if (callBackLocaleModel != null) callBackLocaleModel!();
  }

  /// Update settings with (this) settings
  Future<void> updateSettings() async {
    await _api.updateSettings(settings);
    // Call callback to update settingsModel
    if (callBackSettingsModel != null) callBackSettingsModel!();
    // Call callback to update localeModel
    if (callBackLocaleModel != null) callBackLocaleModel!();
  }
}
