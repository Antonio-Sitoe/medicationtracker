import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/data/models/reminder_with_medication.dart';

class ReminderRepository {
  final CollectionReference _medicollection = FirebaseFirestore.instance
      .collection('medications');
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'reminder',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return uid;
  }

  Future<Reminder> create(Reminder reminder) async {
    final docRef =
        reminder.id != null && reminder.id.isNotEmpty
            ? _collection.doc(reminder.id)
            : _collection.doc();

    await docRef.set({
      ...reminder.toJson(),
      'id': docRef.id,
      'userId': _userId,
    });

    final doc = await docRef.get();
    return Reminder.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> update(Reminder reminder) async {
    await _collection.doc(reminder.id).update(reminder.toJson());
  }

  Future<void> patch(
    String id, {
    String? medicationId,
    DateTime? respondedAt,
    String? actionTaken,
  }) async {
    final updateData = <String, dynamic>{};
    if (medicationId != null) {
      updateData['medicationId'] = medicationId;
    }
    if (actionTaken != null) {
      updateData['actionTaken'] = actionTaken;
    }
    if (respondedAt != null) {
      updateData['respondedAt'] = respondedAt.toIso8601String();
    }
    await _collection.doc(id).update(updateData);
  }

  Future<Reminder?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Reminder.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<List<Reminder>> findMany() async {
    final query = await _collection.where('userId', isEqualTo: _userId).get();
    return query.docs
        .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reminder>> findManyByMedicationId(String medicationId) async {
    final query =
        await _collection
            .where('userId', isEqualTo: _userId)
            .where('medicationId', isEqualTo: medicationId)
            .get();
    return query.docs
        .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, List<ReminderWithMedication>>>
  findManyPastRemindersGroupedByDay() async {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final nowTime = TimeOfDay.fromDateTime(now);

    // 1. Buscar todos os reminders do usuário (sem filtro de createdAt)
    final query = await _collection.where('userId', isEqualTo: _userId).get();

    final reminders =
        query.docs
            .map(
              (doc) =>
                  Reminder.fromJson(doc.data() as Map<String, dynamic>? ?? {}),
            )
            .where((reminder) {
              final createdAt = reminder.createdAt;
              final reminderDate = DateTime(
                createdAt.year,
                createdAt.month,
                createdAt.day,
              );
              final reminderTime = reminder.scheduledTime;

              final isSameOrBeforeToday = !reminderDate.isAfter(todayDate);
              final isTimeBeforeOrEqualNow =
                  reminderTime.hour < nowTime.hour ||
                  (reminderTime.hour == nowTime.hour &&
                      reminderTime.minute <= nowTime.minute);

              return isSameOrBeforeToday && isTimeBeforeOrEqualNow;
            })
            .toList();

    // 2. Buscar os medicamentos relacionados
    final medicationIds = reminders.map((r) => r.medicationId).toSet();

    final medicationsSnap =
        await _medicollection
            .where(FieldPath.documentId, whereIn: medicationIds.toList())
            .get();

    final medicationMap = {
      for (var doc in medicationsSnap.docs) doc.id: doc.data(),
    };

    final reminderWithMedicationList =
        reminders.map((reminder) {
          final medicationData =
              medicationMap[reminder.medicationId] as Map<String, dynamic>?;
          return ReminderWithMedication(
            reminder: reminder,
            medicationName: medicationData?['name'] ?? 'Desconhecido',
          );
        }).toList();

    // 3. Agrupar por data
    final Map<String, List<ReminderWithMedication>> grouped = {};
    for (var item in reminderWithMedicationList) {
      final date = item.reminder.createdAt;
      final dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }

    return grouped;
  }
}
