import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/dosage.dart';
import 'package:medicationtracker/data/models/medication/frequency.dart';

class Medication {
  final String id;
  final String name;
  final String userId;
  final String? instructions;

  final Dosage dosage;
  final Frequency frequency;
  final List<TimeOfDay> scheduledTimes;

  final DateTime startDate;
  final DateTime? endDate;
  final bool receiveReminders;

  Medication({
    required this.id,
    required this.name,
    required this.userId,
    this.instructions,
    required this.dosage,
    required this.frequency,
    required this.scheduledTimes,
    required this.startDate,
    this.endDate,
    required this.receiveReminders,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      instructions: json['instructions'],
      dosage: Dosage.fromJson(json['dosage']),
      frequency: Frequency.fromJson(json['frequency']),
      scheduledTimes:
          (json['scheduledTimes'] as List).map((e) {
            final parts = (e as String).split(":");
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }).toList(),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      receiveReminders: json['receiveReminders'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      if (instructions != null) 'instructions': instructions,
      'dosage': dosage.toJson(),
      'frequency': frequency.toJson(),
      'scheduledTimes':
          scheduledTimes
              .map(
                (t) =>
                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
              )
              .toList(),
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'receiveReminders': receiveReminders,
    };
  }
}
