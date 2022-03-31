import 'package:get_it/get_it.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/core/providers/analytics_model.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/iap_model.dart';
// import 'package:habit_tracker/core/providers/locale_model.dart';
import 'package:habit_tracker/core/providers/settings_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/core/services/review_service.dart';
import 'package:habit_tracker/core/services/settings_service.dart';

/// Get it instance
GetIt locator = GetIt.instance;

/// Initialize locator
void initLocator() {
  // Services
  locator.registerLazySingleton(() => LocalDatabaseApi());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => ReviewService());

  // View models
  locator.registerFactory(() => ThemeNotifier());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => AddEditHabitModel());
  locator.registerFactory(() => AnalyticsModel());
  locator.registerFactory(() => InAppPurchaseModel());
  locator.registerFactory(() => SettingsModel());
  // locator.registerFactory(() => LocaleModel());
}
