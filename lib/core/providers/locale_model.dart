import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

/// Handles the selected locale
class LocaleModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Currently selected locale. Defaults to platform locale (null)
  /// Flutter Localizations finds the nearest from supportedLocals
  Locale? selectedLocale;

  /// Constructor
  LocaleModel() {
    //TODO get locale from database if exists
  }

  /// Set locale to given locale [l]
  void setLocale(Locale l) async {
    selectedLocale = l;
    // TODO await update database
    notifyListeners();
  }
}
