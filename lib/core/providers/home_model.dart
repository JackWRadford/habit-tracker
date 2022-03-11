import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';

class HomeModel extends BaseModel {
  /// Local database API
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    return await _api.getAllHabits();
  }

  /// Add new habit
  Future<void> addNewHabit(Habit h) async {
    await _api.insertHabit(h);
    notifyListeners();
  }

  /// Update given habit [h]
  Future<void> updateHabit(Habit h) async {
    await _api.updateHabit(h);
    notifyListeners();
  }

  /// Delete habit from given id
  Future<void> deleteHabit(int id) async {
    await _api.deleteHabit(id);
    notifyListeners();
  }
}
