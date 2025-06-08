import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';

class MedicationStorage {
  static const _key = 'stored_medications';

  Future<void> saveMedications(List<Medication> medications) async {
    final preference = await SharedPreferences.getInstance();
    final jsonList = medications.map((m) => jsonEncode(m.toJson())).toList();
    await preference.setStringList(_key, jsonList);
  }

  Future<List<Medication>> loadMedications() async {
    final preference = await SharedPreferences.getInstance();
    final jsonList = preference.getStringList(_key) ?? [];
    return jsonList
        .map((jsonStr) => Medication.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
