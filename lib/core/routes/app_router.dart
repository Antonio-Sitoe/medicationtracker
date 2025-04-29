import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/views/screens/login_screan.dart';
import 'package:medicationtracker/views/screens/profile_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicationtracker/views/screens/forgot_password_screen.dart';
import 'package:medicationtracker/views/screens/onboarding_screen.dart';
import 'package:medicationtracker/views/screens/register_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('onboarding_seen') ?? false;

    print("seenOnboarding: $seenOnboarding");

    if (state.uri.toString() == '/') {
      return seenOnboarding ? '/login' : '/onboard';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => null, // Só existe para ser redirecionada
    ),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/profile-selection', builder: (_, __) => ProfileSelection()),
    GoRoute(
      path: '/forgot-password',
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/onboard', builder: (_, __) => const OnboardingScreen()),
  ],
);
