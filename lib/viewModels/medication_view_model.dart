import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/repositories/medication_repository.dart';

class MedicationViewModel extends ChangeNotifier {
  bool isLoading = false;
  final MedicationRepository _repo = MedicationRepository();

  Future<void> create(Medication medication) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.create(medication);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    isLoading = true;
    notifyListeners();

    await _repo.remove(id);

    isLoading = false;
    notifyListeners();
  }

  Future<void> update(Medication medication) async {
    isLoading = true;
    notifyListeners();

    await _repo.update(medication);

    isLoading = false;
    notifyListeners();
  }

  Future<Medication?> findById(String id) async {
    final medication = await _repo.findById(id);
    return medication;
  }

  Future<List<Medication>> findByName(String name) async {
    final medications = await _repo.findByName(name);
    return medications;
  }

  Future<List<Medication>> findMany() async {
    final medications = await _repo.findMany();
    return medications;
  }
}
