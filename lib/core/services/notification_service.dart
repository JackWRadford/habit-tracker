import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/services/database_api.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications initialization
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Initialize local notifications
Future<bool?> initLocalNotifications() async {
  // Initialize time zone database
  tz.initializeTimeZones();

  // Set current local time zone
  tz.setLocalLocation(
    tz.getLocation(
      await FlutterNativeTimezone.getLocalTimezone(),
    ),
  );

  // Android init settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_name');
  // iOS init settings
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );
  var initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
    android: initializationSettingsAndroid,
  );
  return await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    },
  );
}

class NotificationService {
  // Database service instance
  final LocalDatabaseApi _api = locator<LocalDatabaseApi>();

  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();

  /// Method to return if iOS permissions are held
  Future<bool?> notificationPermsHeld() async {
    // Android init settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_name');
    // iOS init settings
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    var initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    return await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
    );
  }

  /// Get last [weekday] occurance from given dateTime [dt]
  ///
  /// [weekday] monday:1, tuesday:2, ...
  DateTime _lastWeekday(DateTime dt, int weekday) {
    // Move back one day intil given weekday
    while (dt.weekday != weekday) {
      dt = DateTime(
        dt.year,
        dt.month,
        dt.day - 1,
        dt.hour,
        dt.minute,
      );
    }
    return dt;
  }

  // Generate id from habit id [hId] and weekday [wd] number
  int _getNotiId(int hId, int wd) {
    return int.parse('$hId$wd');
  }

  /// Toggle disableAllNoti (toggle on/off)
  Future<void> disableAllNoti(bool value, BuildContext ctx) async {
    // if toggle is on (this notifications are disabled)
    if (value) {
      // Cancel all notifications
      await _cancelAllNotifications();
    } else {
      // Schedule all notifications
      var allHabits = await _api.getAllHabits();
      for (var habit in allHabits) {
        await scheduleHabitNoti(habit, ctx);
      }
    }
  }

  /// Schedule reacurring notifications for given [habit]'s requiredDays
  ///
  /// Used when updaing, notiTime, notiToggle, title, requiredDays, deleting
  Future<void> scheduleHabitNoti(Habit habit, BuildContext ctx) async {
    // If settings are disabled, don't schedule new ones
    if (_settingsService.getSettings().disableAllNoti) return;

    String bodyStr = habit.notiBody;

    // Cancel notifications for given habit (incase already scheduled, when updating)
    await cancelNotificationWithId(habit.id!);

    // Schedule if toggled on
    if (habit.notiToggle) {
      // Schedule for required days
      for (var i = 0; i < habit.requiredDays.length; i++) {
        if (habit.requiredDays[i]) {
          _scheduleNotification(
              _getNotiId(habit.id!, i),
              _lastWeekday(habit.notiTime, i + 1),
              habit.title,
              (bodyStr == '')
                  ? AppLocalizations.of(ctx)!.defaultNotiMessage
                  : bodyStr);
        }
      }
    }
  }

  /// Schedule notification to repeat at given [dt] day of the week and time
  Future<void> _scheduleNotification(
    int id,
    DateTime dt,
    String title,
    String content,
  ) async {
    // Android Details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max);
    // IOS Details
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(
      presentAlert: false,
      presentBadge: true,
    );
    // Holds details for iOS and Android
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      content,
      _getTZAware(dt),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Get timezone aware dateTime for given dateTime [dt]
  tz.TZDateTime _getTZAware(DateTime dt) {
    return tz.TZDateTime(
      tz.local,
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
    );
  }

  /// Method to cancel/delete all notifications
  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Method to cancel/delete a notification with given id (habitId)
  Future<void> cancelNotificationWithId(int id) async {
    for (var i = 0; i < 7; i++) {
      await flutterLocalNotificationsPlugin.cancel(_getNotiId(id, i));
    }
  }

  /// Method to get list of all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
