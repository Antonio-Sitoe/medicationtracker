import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/core/services/session_manager.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/data/models/reminder_with_medication.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReminderRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SessionManager _session = SessionManager.instance;

  Future<String> _userId() async {
    final id = await _session.getCurrentUserId();
    if (id == null) {
      throw Exception('Utilizador não autenticado');
    }
    return id;
  }

  Future<Reminder> create(Reminder reminder) async {
    final db = await _db.database;
    final userId = await _userId();
    final id = reminder.id.isNotEmpty ? reminder.id : const Uuid().v4();

    final data = reminder.toMap();
    data['id'] = id;
    data['user_id'] = userId;

    await db.insert(
      'reminders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final rows = await db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return Reminder.fromMap(rows.first);
  }

  Future<void> remove(String id) async {
    final db = await _db.database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Reminder reminder) async {
    final db = await _db.database;
    await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  /// Actualiza apenas os campos passados.
  Future<void> patch(
    String id, {
    String? medicationId,
    DateTime? respondedAt,
    String? actionTaken,
    String? notes,
  }) async {
    final db = await _db.database;
    final updateData = <String, dynamic>{};
    if (medicationId != null) updateData['medication_id'] = medicationId;
    if (actionTaken != null) updateData['action_taken'] = actionTaken;
    if (respondedAt != null) {
      updateData['responded_at'] = respondedAt.toIso8601String();
    }
    if (notes != null) updateData['notes'] = notes;

    if (updateData.isEmpty) return;
    await db.update(
      'reminders',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Reminder?> findById(String id) async {
    final db = await _db.database;
    final rows = await db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Reminder.fromMap(rows.first);
  }

  Future<List<Reminder>> findMany() async {
    final db = await _db.database;
    final userId = await _userId();
    final rows = await db.query(
      'reminders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<List<Reminder>> findManyByMedicationId(String medicationId) async {
    final db = await _db.database;
    final userId = await _userId();
    final rows = await db.query(
      'reminders',
      where: 'user_id = ? AND medication_id = ?',
      whereArgs: [userId, medicationId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<List<ReminderWithMedication>> findAllRemindersWithMedication() async {
    final db = await _db.database;
    final userId = await _userId();

    final rows = await db.rawQuery(
      '''
      SELECT r.*, m.name AS medication_name
      FROM reminders r
      LEFT JOIN medications m ON m.id = r.medication_id
      WHERE r.user_id = ?
      ORDER BY r.created_at DESC
      ''',
      [userId],
    );

    return rows.map((row) {
      return ReminderWithMedication(
        reminder: Reminder.fromMap(row),
        medicationName: (row['medication_name'] as String?) ?? 'Desconhecido',
      );
    }).toList();
  }
}

