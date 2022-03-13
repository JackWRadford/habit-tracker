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

/// List of all [_tableSettings] columns
final List<String>? _settingsColumns = [_colId, _colIsDark];

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
          PRIMARY KEY ($_colId)
          )''',
  2: '''CREATE TABLE IF NOT EXISTS $_tableSettings(
          $_colId INTEGER NOT NULL,
          $_colIsDark INTEGER NOT NULL,
          PRIMARY KEY ($_colId)
          )''',
  3: '''INSERT INTO $_tableSettings ($_colId, $_colIsDark) 
          VALUES(1,0)
          ''',
  4: '''CREATE TABLE IF NOT EXISTS $_tableDays(
          $_colId INTEGER NOT NULL,
          $_colHabitId INTEGER NOT NULL,
          $_colDate TEXT NOT NULL,
          FOREIGN KEY($_colHabitId) REFERENCES $_tableHabits($_colId) ON DELETE CASCADE,
          PRIMARY KEY ($_colId)
          )''',
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

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    List<Habit> habitsList = [];
    // List of habit maps
    List<Map<String, dynamic>> maps = await db.query(
      _tableHabits,
      columns: _habitsColumns,
    );
    // Convert maps to Habits
    for (Map<String, dynamic> map in maps) {
      Habit habit = Habit.fromMap(map);
      // Get lastWeek bool values for given habit
      habit.lastWeek = await _getLastWeek(habit.id!);
      habitsList.add(habit);
    }
    return habitsList;
  }

  /*---------------------Day functions---------------------------*/

  /// Get habitDay list for if day exists for given habit id for last week
  Future<List<HabitDay>> _getLastWeek(int habitId) async {
    List<HabitDay> results = [];
    // Get date without time
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);

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

  /// Insert habitDay
  Future<int> insertHabitDay(HabitDay habitDay) async {
    return await db.insert(_tableDays, habitDay.toMap());
  }

  /// Delete habitDay for given id
  Future<int> deleteHabitDay(int habitDayId) async {
    return await db
        .delete(_tableDays, where: '$_colId = ?', whereArgs: [habitDayId]);
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
