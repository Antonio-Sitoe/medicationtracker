import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';

class MedicationRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'medications',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return uid;
  }

  Future<void> create(Medication medication) async {
    final docRef = await _collection.add({
      ...medication.toJson(),
      'userId': _userId,
    });
    await docRef.update({'id': docRef.id});
  }

  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> update(Medication medication) async {
    if (medication.id == null) {
      print('ID do medicamento não pode ser nulo');
    }
    await _collection.doc(medication.id).update(medication.toJson());
  }

  Future<Medication?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Medication.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<List<Medication>> findByName(String name) async {
    final query =
        await _collection
            .where('userId', isEqualTo: _userId)
            .where('name', isEqualTo: name)
            .get();

    return query.docs
        .map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Medication>> findMany() async {
    final query = await _collection.where('userId', isEqualTo: _userId).get();

    return query.docs
        .map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
