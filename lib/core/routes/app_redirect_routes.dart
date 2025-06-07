import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';

final publicRoutes = [
  AppNamedRoutes.root,
  AppNamedRoutes.splash,
  AppNamedRoutes.login,
  AppNamedRoutes.register,
  AppNamedRoutes.onboard,
  AppNamedRoutes.forgotPassword,
];

String? appRedirectRoutes(GoRouterState state, AuthViewModel auth) {
  final currentRoute = state.matchedLocation;

  if (!auth.isAuthenticated && !publicRoutes.contains(currentRoute)) {
    return AppNamedRoutes.login;
  }

  if (!auth.isOnboardingComplete && currentRoute != AppNamedRoutes.onboard) {
    return AppNamedRoutes.onboard;
  }

  if (auth.isAuthenticated && publicRoutes.contains(currentRoute)) {
    return AppNamedRoutes.patientTabsMedicationsAdd;
  }

  return null;
}
