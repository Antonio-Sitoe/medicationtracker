import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/core/routes/app_redirect_routes.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/screens/patient/history/patient_report_screen.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/add_medication_screen.dart';
import 'package:medicationtracker/views/screens/patient/medication/detail/medication_details_screen.dart';
import 'package:medicationtracker/views/screens/patient/settings/patient_caregivers_screen.dart';
import 'package:medicationtracker/views/screens/patient/settings/patient_configuration_screen.dart';
import 'package:medicationtracker/views/screens/patient/history/patient_historys_screen.dart';
import 'package:medicationtracker/views/screens/patient/home/patient_home_screen.dart';
import 'package:medicationtracker/views/screens/patient/medication/list/patient_medication_screen.dart';
import 'package:medicationtracker/views/screens/patient/settings/patient_profile_screen.dart';
import 'package:medicationtracker/views/screens/patient/patient_root_layout.dart';
import 'package:medicationtracker/views/screens/auth/login.dart';
import 'package:medicationtracker/views/screens/auth/forgot_password_screen.dart';
import 'package:medicationtracker/views/screens/auth/register.dart';
import 'package:medicationtracker/views/screens/onboarding_screen.dart';
import 'package:medicationtracker/views/screens/medication_confirmation.dart';
import 'package:medicationtracker/views/screens/notification_screen.dart';
import 'package:medicationtracker/views/screens/profile_selection.dart';
import 'package:medicationtracker/views/screens/splash_screen.dart';

GoRouter createRouter(AuthViewModel auth) {
  final router = GoRouter(
    initialLocation: AppNamedRoutes.root,
    refreshListenable: auth,
    redirect: (context, state) => appRedirectRoutes(state, auth),
    routes: [
      GoRoute(
        path: AppNamedRoutes.root,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.onboard,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.profileSelection,
        builder: (_, __) => ProfileSelection(),
      ),
      GoRoute(
        path: AppNamedRoutes.medicationConfirmation,
        builder: (_, __) => const MedicationConfirmationScreen(),
      ),
      GoRoute(
        path: AppNamedRoutes.notificationScreen,
        builder: (_, __) => NotificationsScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => PatientRootLayout(child: child),
        routes: [
          GoRoute(
            path: AppNamedRoutes.patientTabsHome,
            builder: (_, __) => PatientHomeScreen(),
          ),
          GoRoute(
            path: AppNamedRoutes.patientTabsMedications,
            builder: (_, __) => PatientMedicationScreen(),
            routes: [
              GoRoute(path: 'add', builder: (_, __) => AddMedicationScreen()),
              GoRoute(
                path: 'details',
                builder: (_, __) => MedicationDetailsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppNamedRoutes.patientTabsHistory,
            builder: (_, __) => PatientHistoryScreen(),
            routes: [
              GoRoute(
                path: 'reports',
                builder: (_, __) => const ReportsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppNamedRoutes.patientTabsSettings,
            builder: (_, __) => PatientConfigurationScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                builder: (_, __) => ProfileSettingsScreen(),
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
  return router;
}
