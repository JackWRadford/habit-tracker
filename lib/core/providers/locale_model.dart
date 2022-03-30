import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/settings_service.dart';

/// Handles the selected locale
class LocaleModel extends BaseModel {
  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();

  /// Currently selected locale. Defaults to platform locale (null)
  /// Flutter Localizations finds the nearest from supportedLocals
  Locale? selectedLocale;

  /// Constructor
  LocaleModel() {
    selectedLocale = _settingsService.getSettings().locale;
  }

  /// Set locale to given locale [l]
  void setLocale(Locale? l) {
    selectedLocale = l;
    // update database
    _settingsService.getSettings().locale = selectedLocale;
    _settingsService.updateSettings();
    notifyListeners();
  }
}
