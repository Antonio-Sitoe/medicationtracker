import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/core/services/session_manager.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';

class MedicationRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SessionManager _session = SessionManager.instance;

  Future<String> _userId() async {
    final id = await _session.getCurrentUserId();
    if (id == null) {
      throw Exception('Utilizador não autenticado');
    }
    return id;
  }

  Future<void> create(Medication medication) async {
    final db = await _db.database;
    final userId = await _userId();
    final data = medication.toMap();
    data['user_id'] = userId;
    await db.insert('medications', data);
  }

  Future<void> remove(String id) async {
    final db = await _db.database;
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Medication medication) async {
    final db = await _db.database;
    await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  Future<Medication?> findById(String id) async {
    final db = await _db.database;
    final rows = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Medication.fromMap(rows.first);
  }

  Future<List<Medication>> findByName(String name) async {
    final db = await _db.database;
    final userId = await _userId();
    final rows = await db.query(
      'medications',
      where: 'user_id = ? AND name = ?',
      whereArgs: [userId, name],
    );
    return rows.map(Medication.fromMap).toList();
  }

  Future<List<Medication>> findMany() async {
    final db = await _db.database;
    final userId = await _userId();
    final rows = await db.query(
      'medications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );
    return rows.map(Medication.fromMap).toList();
  }
}
