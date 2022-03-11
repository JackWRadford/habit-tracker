import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/settings.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_themes.dart';

/// Notify app of selected theme
class ThemeNotifier with ChangeNotifier {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Current settings state
  Settings settings = Settings();

  ThemeNotifier() {
    // Load settings (needed earlier for theme)
    getSettings();
  }

  ///gets settings from the DB and stores in dataService
  Future<void> getSettings() async {
    settings = await _api.getSettings();
    notifyListeners();
  }

  /// Returns bool if dark mode or not
  bool getIsDarkMode() {
    return settings.isDark;
  }

  /// Sets new theme (updates DB)
  setTheme(bool value) async {
    // Update local settings isDark
    settings.isDark = value;
    // Update settings in database
    _api.updateSettings(settings);
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
