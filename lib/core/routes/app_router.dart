import 'package:go_router/go_router.dart';
import 'package:medicationtracker/app_layout.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/core/routes/app_redirect_routes.dart';
import 'package:medicationtracker/data/models/medication.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/history/patient_report_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/medication/add_medication_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/medication/medication_details_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_caregivers_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_configuration_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/history/patient_historys_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/home/patient_home_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/medication/patient_medication_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/settings/patient_profile_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_root_layout.dart';
import 'package:medicationtracker/views/screens/auth/login_screan.dart';
import 'package:medicationtracker/views/screens/auth/forgot_password_screen.dart';
import 'package:medicationtracker/views/screens/auth/register_screen.dart';
import 'package:medicationtracker/views/screens/onboarding_screen.dart';
import 'package:medicationtracker/views/screens/medication_confirmation.dart';
import 'package:medicationtracker/views/screens/notification_screen.dart';
import 'package:medicationtracker/views/screens/profile_selection.dart';
import 'package:medicationtracker/views/screens/splash_screen.dart';

final medicationExample = Medication(
  id: 'med-001',
  name: 'Losartana',
  dosage: '50mg',
  frequency: '2',
  times: ['08:00', '20:00'],
  startDate: DateTime(2025, 5, 20),
  endDate: DateTime(2025, 6, 20),
  active: true,
  instructions: 'Tomar após o café da manhã e após o jantar.',
);

GoRouter createRouter(AuthViewModel auth) {
  final router = GoRouter(
    initialLocation: AppNamedRoutes.root,
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
                builder:
                    (_, __) =>
                        MedicationDetailsScreen(medication: medicationExample),
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
  return router;
}
