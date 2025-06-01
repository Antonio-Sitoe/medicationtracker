import 'dart:io';
import 'package:medicationtracker/core/utils/result.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  Future<Result<UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return Result(data: user);
  }

  Future<void> register(String name, String email, String password) async {
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.updateDisplayName(name);
    await updateUserName(name);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<void> updateUserName(String name) async {
    await currentUser?.updateDisplayName(name);
  }

  Future<void> deleteAccount(String email, String password) async {
    try {
      AuthCredential? credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser?.reauthenticateWithCredential(credential);
      await currentUser?.delete();
      await signOut();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  Future<String?> uploadProfilePicture(String photoPath) async {
    try {
      final File file = File(photoPath);
      final fileName = path.basename(photoPath);
      final userId = currentUser?.uid;

      final ref = _storage.ref().child('profile_pictures/$userId/$fileName');
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  Future<void> resetPasswordFromCurrentPassword(
    String currentPassword,
    String newPassword,
    String email,
  ) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser?.reauthenticateWithCredential(credential);
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to reset password from current password: $e');
    }
  }
}
