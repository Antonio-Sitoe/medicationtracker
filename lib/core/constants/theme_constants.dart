import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF536DFE);
  static const Color primaryDark = Color(0xFF3D5AFE);
  static const Color primaryLight = Color(0xFF9FA8DA);

  static const Color secondary = Color(0xFFFF5722);
  static const Color secondaryDark = Color(0xFFE64A19);
  static const Color secondaryLight = Color(0xFFFFAB91);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  static const Color text = Color(0xFF333333);
  static const Color textLight = Color(0xFF757575);
  static const Color textDark = Color(0xFF212121);

  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F7FA);
  static const Color divider = Color(0xFFE0E0E0);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  static const Color medicationTaken = Color(0xFF4CAF50);
  static const Color medicationMissed = Color(0xFFF44336);
  static const Color medicationUpcoming = Color(0xFFFFC107);
  static const Color medicationActive = Color(0xFF2196F3);
  static const Color medicationInactive = Color(0xFF9E9E9E);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppFontSize {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

class AppFontFamily {
  static const String regular = 'Inter';
  static const String medium = 'Inter';
  static const String semibold = 'Inter';
  static const String bold = 'Inter';
}

class AppShadows {
  static const BoxShadow small = BoxShadow(
    color: Colors.black,
    offset: Offset(0, 2),
    blurRadius: 3,
    spreadRadius: 0,
  );

  static const BoxShadow medium = BoxShadow(
    color: Colors.black,
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: 0,
  );

  static const BoxShadow large = BoxShadow(
    color: Colors.black,
    offset: Offset(0, 8),
    blurRadius: 12,
    spreadRadius: 0,
  );
}
