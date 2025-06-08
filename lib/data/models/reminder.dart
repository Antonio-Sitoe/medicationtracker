import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String medicationId;
  final String title;
  final String body;
  final TimeOfDay scheduledTime;
  final DateTime? respondedAt;
  final String? actionTaken; // 'take', 'snooze', 'dismissed'
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.medicationId,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.respondedAt,
    this.actionTaken,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'title': title,
    'body': body,
    'scheduledTime': scheduledTime.toIso8601String(),
    'respondedAt': respondedAt?.toIso8601String(),
    'actionTaken': actionTaken,
    'createdAt': createdAt.toIso8601String(),
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
    createdAt:
        json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
  );
}

TimeOfDay _parseTimeOfDay(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

extension TimeOfDayExtension on TimeOfDay {
  String toIso8601String() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
