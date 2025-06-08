import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
      },
    );
  }

  showNotification(CustomNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }

  checkForNotifications() async {
    final details =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      showNotification(
        CustomNotification(
          id: 12,
          body: "ss",
          days: [1, 2],
          time: TimeOfDay(hour: 8, minute: 10),
          title: "Agora",
        ),
      );
    }
  }

  Future<bool> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> scheduleAllRemindersFor(Medication med) async {
    if (!med.receiveReminders) return;

    final baseId = med.id.hashCode;
    final specificDays = med.frequency.specificDays ?? [];

    for (int i = 0; i < med.scheduledTimes.length; i++) {
      final timeParts = med.scheduledTimes[i];
      final hour = timeParts.hour;
      final minute = timeParts.minute;
      final time = TimeOfDay(hour: hour, minute: minute);

      if (specificDays.isEmpty) {
        // 🔁 Diário
        await scheduleMedicationReminder(
          id: baseId + i,
          title: 'Tomar ${med.name}',
          body: 'Dosagem: ${med.dosage.quantity} ${med.dosage.unit}',
          time: time,
          days: [],
        );
      } else {
        // 📅 Em dias específicos
        for (final weekDay in specificDays) {
          await scheduleMedicationReminder(
            id: baseId + i * 10 + weekDay,
            title: 'Tomar ${med.name}',
            body: 'Dosagem: ${med.dosage.quantity} ${med.dosage.unit}',
            time: time,
            days: [weekDay],
          );
        }
      }
    }
  }

  Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<int> days, // 0=Domingo ... 6=Sábado
  }) async {
    final now = DateTime.now();
    final scheduledDate = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final androidDetails = AndroidNotificationDetails(
      'medication_channel',
      'Lembretes de Medicamentos',
      channelDescription: 'Notificações para tomar medicamentos',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    if (days.isEmpty) {
      // 🔁 diário
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstance(scheduledDate),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      for (final day in days) {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          _nextInstanceOfWeekday(scheduledDate, day),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  tz.TZDateTime _nextInstance(tz.TZDateTime date) {
    final now = tz.TZDateTime.now(tz.local);
    if (date.isBefore(now)) {
      return date.add(const Duration(days: 1));
    }
    return date;
  }

  tz.TZDateTime _nextInstanceOfWeekday(tz.TZDateTime date, int weekday) {
    final adjusted = date.weekday % 7; // 0-6, domingo-sábado
    int daysAhead = (weekday - adjusted) % 7;
    if (daysAhead == 0 && date.isBefore(tz.TZDateTime.now(tz.local))) {
      daysAhead = 7;
    }
    return date.add(Duration(days: daysAhead));
  }

  Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}
