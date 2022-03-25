import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_themes.dart';

/// Notify app of selected theme
class ThemeNotifier with ChangeNotifier {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();

  ThemeNotifier() {
    // Load settings (needed earlier for theme)
    getSettings();
  }

  ///gets settings from the DB and stores in dataService
  Future<void> getSettings() async {
    await _settingsService.getSettings();
    notifyListeners();
  }

  /// Returns bool if dark mode or not
  bool getIsDarkMode() {
    return _settingsService.settings.isDark;
  }

  /// Sets new theme (updates DB)
  setTheme(bool value) async {
    // Update local settings isDark
    _settingsService.settings.isDark = value;
    // Update settings in database
    _settingsService.updateSettings();
    notifyListeners();
  }

  /// Returns themeData for current theme
  ThemeData getTheme() {
    return getIsDarkMode() ? darkTheme : lightTheme;
  }

  /// Get background colour for current theme
  Color getBGColor() {
    return getIsDarkMode() ? darkBG : lightBG;
  }

  /// Get card colour for current theme
  Color getCardColor() {
    return getIsDarkMode() ? darkCard : lightCard;
  }

  /// Get highlight colour for current theme
  Color getHighlightColor(bool reverse) {
    bool value = getIsDarkMode();
    if (reverse) {
      value = !value;
    }
    return (value) ? Colors.white : Colors.black;
  }
}
