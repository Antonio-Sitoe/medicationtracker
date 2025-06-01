import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/dosage.dart';
import 'package:medicationtracker/data/models/medication/frequency.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/repositories/medication_repository.dart';

class MedicationViewModel extends ChangeNotifier {
  final MedicationRepository _repo = MedicationRepository();

  Future<void> create(String userId) async {
    final medicationFicticio = Medication(
      id: 'med001',
      name: 'Paracetamol',
      userId: userId,
      instructions: 'Tomar após as refeições',
      dosage: Dosage(quantity: 500, unit: DosageUnit.mg),
      frequency: Frequency(type: FrequencyType.daily, specificDays: []),
      scheduledTimes: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 10),
      receiveReminders: true,
    );

    print("==================================================================");
    print(" OBJECTP ${medicationFicticio.toJson()}");

    await _repo.create(medicationFicticio);
  }
}
