import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/core/providers/analytics_model.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/iap_model.dart';
import 'package:habit_tracker/core/providers/settings_model.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/core/services/notification_service.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:habit_tracker/ui/helper/route_view_args.dart';
import 'package:habit_tracker/ui/views/add_edit_habit_view.dart';
import 'package:habit_tracker/ui/views/habit_view.dart';
import 'package:habit_tracker/ui/views/home_view.dart';
import 'package:habit_tracker/ui/views/pro_view.dart';
import 'package:habit_tracker/ui/views/settings_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Local notifications initialization
  await initLocalNotifications();

  // Initialize database
  await initDB();

  // Initialize GetIt Locator
  initLocator();

  // Initialize global settings (SettingsService)
  await initSettings();

  runApp(
    // Wrap app in theme notifier as theme is needed earlier
    MultiProvider(providers: [
      // Theme model
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
      ),
      // // Locale model
      // ChangeNotifierProvider<LocaleModel>(
      //   create: (_) => LocaleModel(),
      // ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // Set preferred device orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        // Home model
        ChangeNotifierProvider<HomeModel>(
          create: (_) => HomeModel(),
        ),
        // Add Edit Habit model
        ChangeNotifierProvider<AddEditHabitModel>(
          create: (_) => AddEditHabitModel(),
        ),
        // Analytics model
        ChangeNotifierProvider<AnalyticsModel>(
          create: (_) => AnalyticsModel(),
        ),
        // IAP model
        ChangeNotifierProvider<InAppPurchaseModel>(
          create: (_) => InAppPurchaseModel(),
        ),
        // Settings model
        ChangeNotifierProvider<SettingsModel>(
          create: (_) => SettingsModel(),
        ),
      ],
      child: GestureDetector(
        // To dismiss active focus when tap outside an input area
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          // Remove ui banner for debug mode
          debugShowCheckedModeBanner: false,
          title: 'Trait',
          // Factories that produce collections of localized values
          // Generated lists, instead of providing them manually
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // supportedLocales: AppLocalizations.supportedLocales,
          supportedLocales: const <Locale>[
            Locale.fromSubtags(languageCode: 'en'),
            // Locale.fromSubtags(languageCode: 'zh'),
            // Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
          ],
          // locale: Provider.of<LocaleModel>(context).selectedLocale,
          // Get app theme from themeNotifier
          theme: Provider.of<ThemeNotifier>(context).getTheme(),
          // Stop native os from scaling text
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: child!,
              ),
            );
          },
          initialRoute: '/',
          // Routes
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) {
                    return const HomeView();
                  },
                );
              case '/addEditHabitView':
                final args = settings.arguments as AddEditHabitArgs;
                return MaterialPageRoute(
                  builder: (context) {
                    return AddEditHabitView(
                      habit: args.habit,
                    );
                  },
                  fullscreenDialog: true,
                );
              case '/habitView':
                final args = settings.arguments as HabitArgs;
                return MaterialPageRoute(
                  builder: (context) {
                    return HabitView(
                      habit: args.habit,
                    );
                  },
                );
              case '/settingsView':
                return MaterialPageRoute(
                  builder: (context) {
                    return const SettingsView();
                  },
                  fullscreenDialog: true,
                );
              case '/proView':
                return MaterialPageRoute(
                  builder: (context) {
                    return const ProView();
                  },
                  fullscreenDialog: true,
                );
              // case '/localsView':
              //   return MaterialPageRoute(
              //     builder: (context) {
              //       return const LocalsView();
              //     },
              //   );
              default:
                return MaterialPageRoute(
                  builder: (context) {
                    return const HomeView();
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

/// Scroll behavior to remove overscroll splash from Android scroll views
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
