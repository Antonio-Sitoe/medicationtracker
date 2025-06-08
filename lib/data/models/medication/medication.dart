import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/dosage.dart';
import 'package:medicationtracker/data/models/medication/frequency.dart';
import 'package:medicationtracker/data/models/medication/status.dart';
import 'package:medicationtracker/views/widgets/frequancy_formatter.dart';

class Medication with FrequencyFormatter {
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

  String getFormattedFrequency() {
    return formatFrequency(frequency.type, frequency.specificDays ?? []);
  }

  MedicationStatus get status {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    if (start.isAfter(today)) {
      return MedicationStatus.pendente;
    }

    if (endDate != null) {
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (end.isBefore(today)) {
        return MedicationStatus.inactivo;
      }
    }

    return MedicationStatus.activo;
  }

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
