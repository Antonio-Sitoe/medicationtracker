import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';

class MedicationRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'medications',
  );

  Future<void> create(Medication medication) async {
    final docRef = await _collection.add(medication.toJson());
    await docRef.update({'id': docRef.id});
  }

  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> update(Medication medication) async {
    await _collection.doc(medication.id).update(medication.toJson());
  }

  Future<Medication?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return Medication.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Medication>> findByName(String name) async {
    final query = await _collection.where('name', isEqualTo: name).get();
    return query.docs
        .map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Medication>> findMany() async {
    final query = await _collection.get();
    return query.docs
        .map((doc) => Medication.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
