import 'package:flutter/foundation.dart';

/// Get current date without time
DateTime getToday() {
  DateTime now = DateTime.now();
  now = DateTime(now.year, now.month, now.day);
  return now;
}

/// Only print if in debug mode
void myPrint(dynamic str) {
  if (kDebugMode) {
    print(str);
  }
}
