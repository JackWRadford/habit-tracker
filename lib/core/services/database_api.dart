import 'package:habit_tracker/core/helper/helper_functions.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/models/settings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Shared columns
const String _colId = 'id'; // Auto increments by default

// Habits table name and columns
const String _tableHabits = 'Habits';
const String _colTitle = 'title';
const String _colColor = 'color';
const String _colMon = 'mon';
const String _colTue = 'tue';
const String _colWed = 'wed';
const String _colThu = 'thu';
const String _colFri = 'fri';
const String _colSat = 'sat';
const String _colSun = 'sun';
const String _colBestStreak = 'bestStreak';
const String _colPos = 'pos';
const String _colChartPeriod = 'chartPeriod';

/// List of all [_tableHabits] columns
final List<String>? _habitsColumns = [
  _colId,
  _colTitle,
  _colColor,
  _colMon,
  _colTue,
  _colWed,
  _colThu,
  _colFri,
  _colSat,
  _colSun,
  _colBestStreak,
  _colPos,
  _colChartPeriod,
];

// Day table name and columns
const String _tableDays = 'Days';
const String _colHabitId = 'habitId';
const String _colDate = 'date';

/// List of all [_tableDays] columns
final List<String>? _daysColumns = [_colId, _colHabitId, _colDate];

// Settings table name and columns
const String _tableSettings = 'Settings';
const String _colIsDark = 'isDark';
const String _colIsPro = 'isPro';
const String _colLocale = 'locale';

/// List of all [_tableSettings] columns
final List<String>? _settingsColumns = [
  _colId,
  _colIsDark,
  _colIsPro,
  _colLocale
];

/// Map of db version to scripts for migration control
Map<int, String> _migrationScripts = {
  1: '''CREATE TABLE IF NOT EXISTS $_tableHabits(
          $_colId INTEGER NOT NULL,
          $_colTitle TEXT NOT NULL,
          $_colColor INTEGER NOT NULL,
          $_colMon INTEGER NOT NULL,
          $_colTue INTEGER NOT NULL,
          $_colWed INTEGER NOT NULL,
          $_colThu INTEGER NOT NULL,
          $_colFri INTEGER NOT NULL,
          $_colSat INTEGER NOT NULL,
          $_colSun INTEGER NOT NULL,
          $_colBestStreak INTEGER NOT NULL,
          PRIMARY KEY ($_colId)
          )''',
  2: '''CREATE TABLE IF NOT EXISTS $_tableSettings(
          $_colId INTEGER NOT NULL,
          $_colIsDark INTEGER NOT NULL,
          $_colIsPro INTEGER NOT NULL,
          PRIMARY KEY ($_colId)
          )''',
  3: '''INSERT INTO $_tableSettings ($_colId, $_colIsDark, $_colIsPro) 
          VALUES(1,0,0)
          ''',
  4: '''CREATE TABLE IF NOT EXISTS $_tableDays(
          $_colId INTEGER NOT NULL,
          $_colHabitId INTEGER NOT NULL,
          $_colDate TEXT NOT NULL,
          FOREIGN KEY($_colHabitId) REFERENCES $_tableHabits($_colId) ON DELETE CASCADE,
          PRIMARY KEY ($_colId)
          )''',
  5: 'ALTER TABLE $_tableSettings ADD COLUMN $_colLocale TEXT',
  6: 'ALTER TABLE $_tableHabits ADD COLUMN $_colPos INTEGER',
  7: 'ALTER TABLE $_tableHabits ADD COLUMN $_colChartPeriod INTEGER',
};

/// Database instance
late Database db;

/// Initialize database [db] and perform required changes/ additions
Future initDB() async {
  // Number of scripts denotes the version number
  int migrationScriptsCount = _migrationScripts.length;
  db = await openDatabase(
    join(
      await getDatabasesPath(),
      'habit_tracker_database.db',
    ),
    version: migrationScriptsCount,
    onConfigure: (db) async {
      await db.execute(
        "PRAGMA foreign_keys = ON",
      );
    },
    onCreate: (db, version) async {
      // Execute all migration scripts
      for (var i = 1; i <= migrationScriptsCount; i++) {
        if (_migrationScripts[i] != null) {
          await db.execute(_migrationScripts[i]!);
        }
      }
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        if (_migrationScripts[i] != null) {
          await db.execute(_migrationScripts[i]!);
        }
      }
    },
  );
}

/// Database api class containing methods to interact with the database
class LocalDatabaseApi {
  /// Close the database
  Future closeDB() async => db.close();

  /*---------------------Habits functions----------------------*/

  /// Insert habit
  Future<int> insertHabit(Habit habit) async {
    return await db.insert(
      _tableHabits,
      habit.toMap(),
    );
  }

  /// Update habit
  Future<int> updateHabit(Habit habit) async {
    return await db.update(_tableHabits, habit.toMap(),
        where: '$_colId = ?', whereArgs: [habit.id]);
  }

  /// Delete habit
  Future<int> deleteHabit(int id) async {
    return await db.delete(
      _tableHabits,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }

  /// Delete all habits
  Future<int> deleteAllHabits() async {
    return await db.delete(_tableHabits);
  }

  /// Get habit for id
  Future<Habit?> getHabitForId(int habitId) async {
    List<Habit> habitsList = [];
    // List of habit maps
    List<Map<String, dynamic>> maps = await db.query(
      _tableHabits,
      columns: _habitsColumns,
      where: '$_colId = ?',
      whereArgs: [habitId],
    );
    // Convert maps to Habits
    for (Map<String, dynamic> map in maps) {
      Habit habit = Habit.fromMap(map);
      habitsList.add(habit);
    }
    if (habitsList.isNotEmpty) {
      return habitsList[0];
    } else {
      return null;
    }
  }

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    List<Habit> habitsList = [];
    // List of habit maps
    List<Map<String, dynamic>> maps = await db.query(
      _tableHabits,
      columns: _habitsColumns,
      orderBy: '$_colPos ASC',
    );
    // Convert maps to Habits
    for (Map<String, dynamic> map in maps) {
      Habit habit = Habit.fromMap(map);
      // Get lastWeek bool values for given habit
      habit.lastWeek = await _getLastWeek(habit.id!);

      // Number of required days in last 5 weeks (based on weekdays selected)
      int requiredDays = 0;
      int numOfWeeks = 5;
      for (bool rDay in habit.requiredDays) {
        if (rDay) requiredDays++;
      }
      requiredDays = requiredDays * numOfWeeks;

      // Calculate date of habitDay 5 weeks ago
      DateTime date = DateTime.now();
      date = DateTime(date.year, date.month, date.day - (7 * numOfWeeks));

      // Get last30 double value
      int count = await habitDaysCountForHabit(habit.id!, date, getToday());
      habit.last30 = (count / requiredDays);
      habitsList.add(habit);
    }
    return habitsList;
  }

  /// Get number of habits
  Future<int> getHabitsCount() async {
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableHabits'));
    return (count != null) ? count : 0;
  }

  /*---------------------Day functions---------------------------*/

  /// Get if there is a HabitDay for the given [habitId] and [date]
  Future<bool> isDayForHabit(int habitId, DateTime date) async {
    // List of habitDay maps
    List<Map<String, dynamic>> maps = await db.query(
      _tableDays,
      columns: _daysColumns,
      where: '$_colHabitId = ? AND $_colDate = ?',
      whereArgs: [habitId, date.toIso8601String()],
    );
    return (maps.isNotEmpty);
  }

  /// Get number of HabitDays for given [habitId] between dates [from] & [to]
  Future<int> habitDaysCountForHabit(
      int habitId, DateTime from, DateTime to) async {
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $_tableDays WHERE $_colHabitId = ? AND date($_colDate) BETWEEN date(?) AND date(?)',
        [habitId, from.toIso8601String(), to.toIso8601String()]));
    return (count != null) ? count : 0;
  }

  /// Get number of HabitDays for given [habitId]
  Future<int> allHabitDaysCountForHabit(int habitId) async {
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $_tableDays WHERE $_colHabitId = ?', [habitId]));
    return (count != null) ? count : 0;
  }

  /// Get oldest date of HabitDay for given [habitId]
  Future<DateTime?> oldestDateOfHabitDay(int habitId) async {
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT $_colDate FROM $_tableDays WHERE $_colHabitId = ? ORDER BY $_colDate ASC',
        [habitId]);
    if (maps.isNotEmpty) {
      if (maps[0].isNotEmpty) {
        return DateTime.parse(maps[0].values.toList().first);
      }
    }
    return null;
  }

  /// Get habitDay list for if day exists for given [habitId] for last week
  Future<List<HabitDay>> _getLastWeek(int habitId) async {
    List<HabitDay> results = [];
    // Get date without time
    DateTime now = getToday();

    for (var i = 0; i < 7; i++) {
      // Get row map if exists from Days table
      List<Map<String, dynamic>> maps = await db.query(_tableDays,
          columns: _daysColumns,
          where: '$_colHabitId = ? AND $_colDate = ?',
          whereArgs: [habitId, now.toIso8601String()]);

      // Convert from map to habitDay if exists, else add false habitDay
      results.add((maps.isNotEmpty)
          ? HabitDay.fromMap(maps[0])
          : HabitDay(habitId: habitId, date: now, isDone: false));

      // Decrement now by one day
      now = DateTime(now.year, now.month, now.day - 1);
    }
    return results;
  }

  /// get habitDay list for last year for given [habitId] (to this date last year)
  Future<List<HabitDay>> getDaysFrom(int habitId, DateTime f) async {
    List<HabitDay> results = [];
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_tableDays WHERE $_colHabitId = ? AND date($_colDate) > date(?) ORDER BY $_colDate ASC',
        [habitId, f.toIso8601String()]);
    for (Map<String, dynamic> map in maps) {
      HabitDay hd = HabitDay.fromMap(map);
      results.add(hd);
    }
    return results;
  }

  /// Insert [habitDay]
  Future<int> insertHabitDay(HabitDay habitDay) async {
    return await db.insert(_tableDays, habitDay.toMap());
  }

  /// Delete habitDay for given [habitDayId]
  Future<int> deleteHabitDay(int habitDayId) async {
    return await db
        .delete(_tableDays, where: '$_colId = ?', whereArgs: [habitDayId]);
  }

  /// Delete all habitDays for given [habitId]
  Future<int> deleteHabitDaysForHabit(int habitId) async {
    return await db
        .delete(_tableDays, where: '$_colHabitId = ?', whereArgs: [habitId]);
  }

  /*---------------------Settings functions----------------------*/

  /// Insert settings
  Future<int> insertSettings(Settings settings) async {
    return await db.insert(_tableSettings, settings.toMap());
  }

  /// Update settings
  Future<int> updateSettings(Settings settings) async {
    return await db.update(_tableSettings, settings.toMap(),
        where: '$_colId = ?', whereArgs: [settings.id]);
  }

  /// Delete settings
  Future<int> deleteSettings(int id) async {
    return await db.delete(
      _tableSettings,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }

  /// Get settings (id 1 ONLY SETTINGS)
  Future<Settings> getSettings() async {
    List<Settings> settingsList = [];
    // Get list of settings maps (should only be one)
    List<Map<String, dynamic>> maps = await db.query(
      _tableSettings,
      columns: _settingsColumns,
    );

    // Convert maps to Settings
    for (Map<String, dynamic> map in maps) {
      Settings settings = Settings.fromMap(map);
      settingsList.add(settings);
    }
    return settingsList[0];
  }
}
