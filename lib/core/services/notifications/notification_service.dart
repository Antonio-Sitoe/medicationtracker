import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/app_layout.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/core/services/notifications/medication_storage.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/data/repositories/reminder_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';

class NotificationService {
  final _medStorage = MedicationStorage();
  final ReminderRepository _reminderRepository = ReminderRepository();
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload == null) return;

        final data = jsonDecode(payload);
        final reminder = Reminder.fromJson(data['reminder']);

        print("REMINDER ${reminder.toJson()}");

        switch (response.actionId) {
          case 'TAKE_MED':
            await _reminderRepository.patch(
              reminder.id,
              actionTaken: "take",
              respondedAt: DateTime.now(),
            );
            break;
          case 'DEFER_MED':
            await _reminderRepository.patch(
              reminder.id,
              actionTaken: "dismissed",
              respondedAt: DateTime.now(),
            );
            break;
          default:
            GoRouter.of(
              navigatorKey.currentContext!,
            ).push(AppNamedRoutes.medicationConfirmation, extra: reminder);
            break;
        }
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

    String title = 'Medicação ${med.name}';
    final body = 'Dosagem: ${med.dosage.quantity} ${med.dosage.unit.name}';

    String medicationId = med.id;
    String reminderId = Uuid().v4();
    final baseId = med.id.hashCode;
    final specificDays = med.frequency.specificDays ?? [];
    final List<int> scheduledIds = [];

    for (int i = 0; i < med.scheduledTimes.length; i++) {
      final timeParts = med.scheduledTimes[i];
      final hour = timeParts.hour;
      final minute = timeParts.minute;
      final time = TimeOfDay(hour: hour, minute: minute);
      final payloadTitle = "$title: ás $hour:$minute 💊⏰";
      if (specificDays.isEmpty) {
        Reminder reminder = await saveReminder(
          medicationId,
          reminderId,
          title,
          time,
          body,
        );

        final payload = jsonEncode({'reminder': reminder});
        final id = baseId + i;
        await scheduleMedicationReminder(
          id: id,
          title: payloadTitle,
          body: body,
          time: time,
          days: [],
          payload: payload,
        );
        scheduledIds.add(id);
      } else {
        // 📅 Em dias específicos
        for (final weekDay in specificDays) {
          final id = baseId + i * 10 + weekDay;
          Reminder reminder = await saveReminder(
            medicationId,
            reminderId,
            title,
            time,
            body,
          );

          final payload = jsonEncode({'reminder': reminder});
          await scheduleMedicationReminder(
            id: id,
            title: payloadTitle,
            body: body,
            time: time,
            days: [weekDay],
            payload: payload,
          );
        }
      }

      await saveScheduledReminderIds(med.id, scheduledIds);
    }
  }

  Future<Reminder> saveReminder(
    String medicationId,
    String reminderId,
    String title,
    TimeOfDay time,
    String body,
  ) async {
    return await _reminderRepository.create(
      Reminder(
        id: reminderId,
        medicationId: medicationId,
        title: title,
        body: body,
        scheduledTime: time,
      ),
    );
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
    required String payload,
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
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'TAKE_MED',
          'Tomar',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'DEFER_MED',
          'Adiar',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
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
        payload: payload,
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
          payload: payload,
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
