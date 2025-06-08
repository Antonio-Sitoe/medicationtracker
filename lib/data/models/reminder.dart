import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String medicationId;
  final String title;
  final String body;
  final TimeOfDay scheduledTime;
  final DateTime? respondedAt;
  final String? actionTaken; // 'take', 'snooze', 'dismissed',

  Reminder({
    required this.id,
    required this.medicationId,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.respondedAt,
    this.actionTaken,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'title': title,
    'body': body,
    'scheduledTime': scheduledTime.toIso8601String(),
    'respondedAt': respondedAt?.toIso8601String(),
    'actionTaken': actionTaken,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    medicationId: json['medicationId'],
    title: json['title'],
    body: json['body'],
    scheduledTime: _parseTimeOfDay(json['scheduledTime']),
    respondedAt:
        json['respondedAt'] != null
            ? DateTime.parse(json['respondedAt'])
            : null,
    actionTaken: json['actionTaken'],
  );
}

TimeOfDay _parseTimeOfDay(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

extension on TimeOfDay {
  String toIso8601String() {
    return '$hour:$minute';
  }
}
