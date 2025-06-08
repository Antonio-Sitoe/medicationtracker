import 'package:medicationtracker/data/models/reminder.dart';

class ReminderWithMedication {
  final Reminder reminder;
  final String medicationName;

  ReminderWithMedication({
    required this.reminder,
    required this.medicationName,
  });
}
