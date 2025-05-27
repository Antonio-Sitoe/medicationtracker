import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationtracker/data/models/userModel.dart';

class UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _users.doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUserById(String id) async {
    final userDoc = await _users.doc(id).get();
    if (!userDoc.exists) return null;
    return UserModel.fromJson(userDoc.data()!..['id'] = userDoc.id);
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _users.doc(id).delete();
  }

  Stream<List<UserModel>> getUsers() {
    return _users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }).toList();
    });
  }
}
