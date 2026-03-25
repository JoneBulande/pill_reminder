import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Lógica ao clicar na notificação
      },
    );
  }

  Future<void> requestPermissions() async {
    // Android
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    // iOS
    final iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    int? intervalHours,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Reminders',
      channelDescription: 'Canal para lembretes de remédio',
      importance: Importance.high,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: darwinPlatformChannelSpecifics,
        );

    final int intervals = (intervalHours != null && intervalHours > 0) ? (24 ~/ intervalHours) : 1;

    for (int i = 0; i < intervals; i++) {
        final currentScheduledTime = scheduledTime.add(Duration(hours: i * (intervalHours ?? 24)));
        final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(currentScheduledTime, tz.local);
        
        await _notificationsPlugin.zonedSchedule(
          id: id * 100 + i, // Evita colisão entre diferentes medicamentos e seus intervalos
          title: title,
          body: body,
          scheduledDate: tzScheduledTime,
          notificationDetails: platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
    }
  }

  Future<void> cancelNotification(int id) async {
    // Como agendamos com id * 100 + i (onde i pode ir até 5 para 4h interval), vamos cancelar os possíveis 6 slots
    for (int i = 0; i < 6; i++) {
        await _notificationsPlugin.cancel(id: id * 100 + i);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
