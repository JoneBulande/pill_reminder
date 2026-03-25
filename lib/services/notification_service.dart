import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Emits the medicine id (as String) when a notification is tapped.
  static final ValueNotifier<String?> selectedMedicineId =
      ValueNotifier<String?>(null);

  // ── Init ────────────────────────────────────────────────────────────

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload!.isNotEmpty) {
          selectedMedicineId.value = details.payload;
        }
      },
    );
  }

  Future<void> requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }

    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      await iosImpl.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // ── Scheduling ──────────────────────────────────────────────────────

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    int? intervalHours,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Lembretes de Remédio',
      channelDescription: 'Lembretes para tomar medicamentos',
      importance: Importance.high,
      priority: Priority.high,
      fullScreenIntent: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final intervals = (intervalHours != null && intervalHours > 0)
        ? (24 ~/ intervalHours)
        : 1;
    final payload = id.toString();

    for (int i = 0; i < intervals; i++) {
      final scheduled =
          scheduledTime.add(Duration(hours: i * (intervalHours ?? 24)));
      final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

      await _plugin.zonedSchedule(
        id: id * 100 + i,
        title: title,
        body: body,
        scheduledDate: tzScheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    }
  }

  // ── Cancel ──────────────────────────────────────────────────────────

  /// Cancel all notification slots for the given medicine id.
  Future<void> cancelNotification(int id) async {
    // We schedule up to 24 ÷ 4 = 6 slots maximum (4 h interval)
    for (int i = 0; i < 6; i++) {
      await _plugin.cancel(id: id * 100 + i);
    }
  }

  Future<void> cancelAllNotifications() async => _plugin.cancelAll();
}
