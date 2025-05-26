class AppNamedRoutes {
  // Auth
  static const String root = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String onboard = '/onboard';
  static const String profileSelection = '/profile-selection';

  // Tabs Root
  static const String patientTabsHome = '/patient-tabs/home';
  static const String patientTabsMedications = '/patient-tabs/medications';
  static const String patientTabsMedicationsAdd =
      '/patient-tabs/medications/add';
  static const String patientTabsMedicationsDetails =
      '/patient-tabs/medications/details';
  static const String patientTabsHistory = '/patient-tabs/history';
  static const String patientTabsHistoryReports =
      '/patient-tabs/history/reports';
  static const String patientTabsSettings = '/patient-tabs/settings';
  static const String patientTabsSettingsProfile =
      '/patient-tabs/settings/profile';
  static const String patientTabsSettingsCaregiver =
      '/patient-tabs/settings/caregiver';

  // Extras
  static const String medicationConfirmation = '/medication-confirmation';
  static const String notificationScreen = '/notification-screen';
}
