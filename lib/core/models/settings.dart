import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings {
  int? id;
  bool isDark = false;
  bool isPro = false;
  Locale? locale;
  bool disableAllNoti = false;

  Settings();

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'isDark': (isDark) ? 1 : 0,
      'isPro': (isPro) ? 1 : 0,
      'locale': locale.toString(),
      'disableAllNoti': (disableAllNoti) ? 1 : 0,
    };
  }

  /// Convert from Map
  Settings.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    isDark = (map['isDark'] == 1);
    isPro = (map['isPro'] == 1);
    locale = _stringToLocale(map['locale']);
    disableAllNoti = (map['disableAllNoti'] == 1);
  }

  /// Convert from string to locale
  Locale? _stringToLocale(String? s) {
    if (s == null) return null;
    // Get locale from supportedLocales (if string matches)
    for (Locale l in AppLocalizations.supportedLocales) {
      if (l.toString() == s) return l;
    }
    return null;
  }
}
