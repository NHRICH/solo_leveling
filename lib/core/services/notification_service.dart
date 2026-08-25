import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:solo_leveling/main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  /// Fixed notification IDs for the Focus Dungeon so the live countdown and
  /// the scheduled completion alert can be updated/cancelled reliably.
  static const int _focusOngoingId = 9001;
  static const int _focusCompleteId = 9002;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _timezoneInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Use default small icon for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload == 'restart_app' ||
            response.actionId == 'restart_app_action') {
          final context = navigatorKey.currentContext;
          if (context != null) {
            Phoenix.rebirth(context);
          }
        }
      },
    );

    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> _ensureTimezones() async {
    if (_timezoneInitialized) return;
    tzdata.initializeTimeZones();
    _timezoneInitialized = true;
  }

  /// Requests the ability to schedule exact alarm notifications (Android 12+).
  /// Used so the "dungeon complete" alert can fire on-time even if the app is
  /// backgrounded or killed.
  Future<void> requestExactAlarmPermission() async {
    await init();
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  /// Shows (or updates) the ongoing, non-dismissible live countdown
  /// notification for the Focus Dungeon while a session is running.
  Future<void> showFocusCountdownNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await init();
    await requestPermissions();

    const AndroidNotificationDetails details = AndroidNotificationDetails(
      'focus_dungeon_channel',
      'Focus Dungeon',
      channelDescription: 'Live countdown and completion alerts for focus sessions',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      category: AndroidNotificationCategory.stopwatch,
    );

    await flutterLocalNotificationsPlugin.show(
      id: _focusOngoingId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: details),
    );
  }

  /// Removes the live countdown notification (e.g. when the session is
  /// paused, reset, or completed). Safe to call even if the plugin has not
  /// been initialized / a platform instance is unavailable, so it can be used
  /// from `dispose()` without risking an exception during teardown.
  Future<void> cancelFocusCountdownNotification() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _focusOngoingId);
    } catch (_) {
      // No-op if the plugin isn't ready (e.g. in tests or before init).
    }
  }

  /// Schedules a one-shot notification at [when] to alert that the focus
  /// session has ended. Fires on-time even if the app is backgrounded or has
  /// been killed (as long as the user granted exact-alarm permission).
  Future<void> scheduleFocusCompletion({
    DateTime? when,
    String body = 'Your Focus Dungeon has ended. Great work, hunter!',
  }) async {
    await _ensureTimezones();
    if (when == null || when.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'focus_dungeon_channel',
      'Focus Dungeon',
      channelDescription: 'Live countdown and completion alerts for focus sessions',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
    );

    final NotificationDetails details = const NotificationDetails(
      android: androidDetails,
    );

    // `.from(when, tz.UTC)` preserves the absolute instant, so the OS fires at
    // the exact real-world moment regardless of the device's time zone.
    final scheduled = tz.TZDateTime.from(when, tz.UTC);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id: _focusCompleteId,
          title: 'Dungeon Complete!',
          body: body,
          scheduledDate: scheduled,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (_) {
        // Exact alarm permission may be missing — fall back to inexact.
        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id: _focusCompleteId,
            title: 'Dungeon Complete!',
            body: body,
            scheduledDate: scheduled,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        } catch (_) {
          // No scheduling support; silently skip. The in-app timer still works.
        }
      }
  }

  /// Cancels the pending completion alert (e.g. when a run is paused/reset).
  Future<void> cancelFocusCompletion() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _focusCompleteId);
    } catch (_) {
      // No-op if the plugin isn't ready (e.g. in tests or before init).
    }
  }

  /// NOTE: instant notification for backup and restore
  /// arguments: id, title, body, payload
  /// eg:  id = 1
  ///      title = 'Backup saved'
  ///      body = 'Backup saved successfully'
  ///      payload = 'backup'
  Future<void> showInstantBackupAndRestoreNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool showRestartButton = false,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'instant_backup_and_restore_channel_id',
          'Backup and restore',
          importance: Importance.max,
          priority: Priority.high,
          actions: showRestartButton
              ? <AndroidNotificationAction>[
                  const AndroidNotificationAction(
                    'restart_app_action',
                    'Restart App',
                    cancelNotification: true,
                    showsUserInterface: true,
                  ),
                ]
              : null,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: 'restart_app',
    );
  }
}
