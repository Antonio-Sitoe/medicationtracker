import 'dart:convert';

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

  static String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static TimeOfDay _parseTime(String s) {
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Constrói a partir de uma linha SQLite (tabela `medications`).
  factory Medication.fromMap(Map<String, dynamic> map) {
    final timesRaw = (map['scheduled_times'] as String?) ?? '';
    final times = timesRaw
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map(_parseTime)
        .toList();

    final specificDaysRaw = map['frequency_specific_days'] as String?;
    final specificDays = (specificDaysRaw == null || specificDaysRaw.isEmpty)
        ? <int>[]
        : specificDaysRaw
              .split(',')
              .where((e) => e.trim().isNotEmpty)
              .map(int.parse)
              .toList();

    return Medication(
      id: map['id'] as String,
      name: map['name'] as String,
      userId: map['user_id'] as String,
      instructions: map['instructions'] as String?,
      dosage: Dosage(
        quantity: (map['dosage_quantity'] as num).toDouble(),
        unit: DosageUnit.values.firstWhere(
          (e) => e.name == (map['dosage_unit'] as String),
          orElse: () => DosageUnit.mg,
        ),
      ),
      frequency: Frequency(
        type: map['frequency_type'] as String,
        intervalInDays: map['frequency_interval_in_days'] as int?,
        specificDays: specificDays,
      ),
      scheduledTimes: times,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      receiveReminders: ((map['receive_reminders'] as int?) ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'instructions': instructions,
      'dosage_quantity': dosage.quantity,
      'dosage_unit': dosage.unit.name,
      'frequency_type': frequency.type,
      'frequency_interval_in_days': frequency.intervalInDays,
      'frequency_specific_days':
          (frequency.specificDays ?? []).map((d) => d.toString()).join(','),
      'scheduled_times': scheduledTimes.map(_formatTime).join(','),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'receive_reminders': receiveReminders ? 1 : 0,
    };
  }

  /// Mantido para compatibilidade com o `MedicationStorage` baseado em
  /// SharedPreferences (usado pelo serviço de notificações).
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      instructions: json['instructions'],
      dosage: Dosage.fromJson(json['dosage']),
      frequency: Frequency.fromJson(json['frequency']),
      scheduledTimes: (json['scheduledTimes'] as List)
          .map((e) => _parseTime(e as String))
          .toList(),
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
      'scheduledTimes': scheduledTimes.map(_formatTime).toList(),
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'receiveReminders': receiveReminders,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
