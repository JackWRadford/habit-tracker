import 'package:get_it/get_it.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';

/// Get it instance
GetIt locator = GetIt.instance;

/// Initialize locator
void initLocator() {
  // Services
  locator.registerLazySingleton(() => LocalDatabaseApi());

  // View models
  locator.registerFactory(() => ThemeNotifier());
  locator.registerFactory(() => HomeModel());
}
