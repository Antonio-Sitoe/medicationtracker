import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/core/services/session_manager.dart';
import 'package:medicationtracker/data/models/caregiver.dart';
import 'package:uuid/uuid.dart';

class CaregiverRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SessionManager _session = SessionManager.instance;

  Future<String> _patientId() async {
    final id = await _session.getCurrentUserId();
    if (id == null) {
      throw Exception('Utilizador não autenticado');
    }
    return id;
  }

  Future<Caregiver> create({
    required String name,
    required String email,
    String? relationship,
    String? photo,
  }) async {
    final db = await _db.database;
    final patientId = await _patientId();
    final caregiver = Caregiver(
      id: const Uuid().v4(),
      patientId: patientId,
      name: name,
      email: email.trim().toLowerCase(),
      relationship: relationship,
      photo: photo,
      isLinked: false,
    );
    await db.insert('caregivers', caregiver.toMap());
    return caregiver;
  }

  Future<void> remove(String id) async {
    final db = await _db.database;
    await db.delete('caregivers', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Caregiver caregiver) async {
    final db = await _db.database;
    await db.update(
      'caregivers',
      caregiver.toMap(),
      where: 'id = ?',
      whereArgs: [caregiver.id],
    );
  }

  Future<List<Caregiver>> findMany() async {
    final db = await _db.database;
    final patientId = await _patientId();
    final rows = await db.query(
      'caregivers',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Caregiver.fromMap).toList();
  }
}
