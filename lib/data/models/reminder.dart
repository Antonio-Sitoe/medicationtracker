import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String medicationId;
  final String userId;
  final String title;
  final String body;
  final TimeOfDay scheduledTime;
  final DateTime? respondedAt;
  final String? actionTaken; // 'take', 'snooze', 'dismissed'
  final String? notes;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.medicationId,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.userId = '',
    this.respondedAt,
    this.actionTaken,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'medication_id': medicationId,
        'title': title,
        'body': body,
        'scheduled_time': scheduledTime.toIso8601String(),
        'responded_at': respondedAt?.toIso8601String(),
        'action_taken': actionTaken,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Reminder.fromMap(Map<String, dynamic> map) => Reminder(
        id: map['id'] as String,
        userId: (map['user_id'] as String?) ?? '',
        medicationId: map['medication_id'] as String,
        title: map['title'] as String,
        body: map['body'] as String,
        scheduledTime: _parseTimeOfDay(map['scheduled_time'] as String),
        respondedAt: map['responded_at'] != null
            ? DateTime.parse(map['responded_at'] as String)
            : null,
        actionTaken: map['action_taken'] as String?,
        notes: map['notes'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : DateTime.now(),
      );

  // Mantido para compatibilidade com os payloads JSON usados no canal de
  // notificações locais.
  Map<String, dynamic> toJson() => {
        'id': id,
        'medicationId': medicationId,
        'userId': userId,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime.toIso8601String(),
        'respondedAt': respondedAt?.toIso8601String(),
        'actionTaken': actionTaken,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'],
        userId: json['userId'] ?? '',
        medicationId: json['medicationId'],
        title: json['title'],
        body: json['body'],
        scheduledTime: _parseTimeOfDay(json['scheduledTime']),
        respondedAt: json['respondedAt'] != null
            ? DateTime.parse(json['respondedAt'])
            : null,
        actionTaken: json['actionTaken'],
        notes: json['notes'],
        createdAt: json['createdAt'] != null
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
