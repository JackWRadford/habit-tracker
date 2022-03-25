class Settings {
  int? id;
  bool isDark = false;
  bool isPro = false;

  Settings();

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'isDark': (isDark) ? 1 : 0,
      'isPro': (isPro) ? 1 : 0,
    };
  }

  /// Convert from Map
  Settings.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    isDark = (map['isDark'] == 1);
    isPro = (map['isPro'] == 1);
  }
}
