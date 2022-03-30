import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

/// Handles the selected locale
class LocaleModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Currently selected locale. Defaults to platform locale
  Locale selectedLocale =
      Locale.fromSubtags(languageCode: Platform.localeName.substring(0, 2));

  /// Constructor
  LocaleModel() {
    //TODO get locale from database if exists. else use platform
  }

  /// Set locale to given locale [l]
  void setLocale(Locale l) async {
    selectedLocale = l;
    // TODO await update database
    notifyListeners();
  }
}
