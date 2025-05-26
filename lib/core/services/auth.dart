import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in: ${user.user?.email}');
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
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
