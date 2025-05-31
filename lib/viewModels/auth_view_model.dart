import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicationtracker/core/services/auth.dart';
import 'package:medicationtracker/core/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isOnboardingComplete = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  bool get isOnboardingComplete => _isOnboardingComplete;

  AuthViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _loadOnboardingStatus();

    _authService.userStream.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> reloadUser() async {
    await _authService.currentUser?.reload();
    _currentUser = _authService.currentUser;
    notifyListeners();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingComplete = prefs.getBool('onboarding_seen') ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    _isOnboardingComplete = true;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    await _authService.register(username, email, password);
    notifyListeners();

    await reloadUser();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
    notifyListeners();
  }

  Future<Result> signIn(String email, String password) async {
    final result = await _authService.signInWithEmail(email, password);
    notifyListeners();
    return result;
  }

  Future<void> uploadProfileImage(String path) async {
    await _authService.uploadProfilePicture(path);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
