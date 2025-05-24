import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/history/patient_report_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_caregivers_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_configuration_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/history/patient_historys_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/home/patient_home_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/medication/patient_medication_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_profile_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_root_layout.dart';
import 'package:medicationtracker/views/screens/auth/login_screan.dart';
import 'package:medicationtracker/views/screens/notification_screen.dart';
import 'package:medicationtracker/views/screens/profile_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicationtracker/views/screens/auth/forgot_password_screen.dart';
import 'package:medicationtracker/views/screens/onboarding_screen.dart';
import 'package:medicationtracker/views/screens/auth/register_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('onboarding_seen') ?? false;
    if (state.uri.toString() == '/') {
      return seenOnboarding ? '/login' : '/onboard';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (_, __) => null),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/onboard', builder: (_, __) => const OnboardingScreen()),
    GoRoute(
      path: '/notification-screen',
      builder: (_, __) => NotificationsScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/profile-selection', builder: (_, __) => ProfileSelection()),

    /// ShellRoute para abas do paciente
    ShellRoute(
      builder: (context, state, child) => PatientRootLayout(child: child),
      routes: [
        GoRoute(
          path: '/patient-tabs/home',
          builder: (_, __) => PatientHomeScreen(),
        ),
        GoRoute(
          path: '/patient-tabs/medications',
          builder: (_, __) => PatientMedicationScreen(),
        ),
        GoRoute(
          path: '/patient-tabs/history',
          builder: (_, __) => PatientHistoryScreen(),
          routes: [
            GoRoute(path: 'reports', builder: (_, __) => const ReportsScreen()),
          ],
        ),
        GoRoute(
          path: '/patient-tabs/settings',
          builder: (_, __) => PatientConfigurationScreen(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (_, __) => const ProfileSettingsScreen(),
            ),
            GoRoute(
              path: 'caregiver',
              builder: (_, __) => const PatientCaregiversScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
