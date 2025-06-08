import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:medicationtracker/core/services/notifications/medication_storage.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final _medStorage = MedicationStorage();
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

    await reScheduleAllReminders();
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

    await cancelAllRemindersFor(med.id);

    final baseId = med.id.hashCode;
    final specificDays = med.frequency.specificDays ?? [];
    final List<int> scheduledIds = [];

    for (int i = 0; i < med.scheduledTimes.length; i++) {
      final timeParts = med.scheduledTimes[i];
      final hour = timeParts.hour;
      final minute = timeParts.minute;
      final time = TimeOfDay(hour: hour, minute: minute);

      if (specificDays.isEmpty) {
        final id = baseId + i;
        await scheduleMedicationReminder(
          id: id,
          title: 'Tomar ${med.name}',
          body: 'Dosagem: ${med.dosage.quantity} ${med.dosage.unit}',
          time: time,
          days: [],
        );
        scheduledIds.add(id);
      } else {
        // 📅 Em dias específicos
        for (final weekDay in specificDays) {
          final id = baseId + i * 10 + weekDay;
          await scheduleMedicationReminder(
            id: id,
            title: 'Tomar ${med.name}',
            body: 'Dosagem: ${med.dosage.quantity} ${med.dosage.unit}',
            time: time,
            days: [weekDay],
          );
        }
      }

      await saveScheduledReminderIds(med.id, scheduledIds);
    }
  }

  Future<void> cancelAllRemindersFor(String medicationId) async {
    final ids = await getScheduledReminderIds(medicationId);
    for (final id in ids) {
      await _notificationsPlugin.cancel(id);
    }
    await saveScheduledReminderIds(medicationId, []);
  }

  Future<void> saveScheduledReminderIds(String medId, List<int> ids) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setStringList(
      medId,
      ids.map((e) => e.toString()).toList(),
    );
  }

  Future<List<int>> getScheduledReminderIds(String medId) async {
    final preference = await SharedPreferences.getInstance();
    return preference.getStringList(medId)?.map(int.parse).toList() ?? [];
  }

  Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<int> days,
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
    final adjusted = date.weekday % 7;
    int daysAhead = (weekday - adjusted) % 7;
    if (daysAhead == 0 && date.isBefore(tz.TZDateTime.now(tz.local))) {
      daysAhead = 7;
    }
    return date.add(Duration(days: daysAhead));
  }

  Future<void> reScheduleAllReminders() async {
    final List<Medication> meds = await _medStorage.loadMedications();
    for (final med in meds) {
      await NotificationService().scheduleAllRemindersFor(med);
    }
  }

  Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}
