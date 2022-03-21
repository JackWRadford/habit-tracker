/// Get current date without time
DateTime getToday() {
  DateTime now = DateTime.now();
  now = DateTime(now.year, now.month, now.day);
  return now;
}
