import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicationtracker/core/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool isLoading = true;
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
      isLoading = false;
      notifyListeners();
    });
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

  Future<void> register(String email, String password) async {
    isLoading = true;
    notifyListeners();
    await _authService.register(email, password);
    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    await _authService.signInWithEmail(email, password);
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    isLoading = false;
    notifyListeners();
  }
}
