import 'package:flutter/material.dart';
import 'theme_constants.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    // ignore: deprecated_member_use
    background: AppColors.background,
    error: AppColors.error,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.white,
      fontSize: AppFontSize.lg,
      fontFamily: AppFontFamily.bold,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: AppFontSize.xxxl,
      fontFamily: AppFontFamily.bold,
      color: AppColors.text,
    ),
    titleLarge: TextStyle(
      fontSize: AppFontSize.xxl,
      fontFamily: AppFontFamily.semibold,
      color: AppColors.text,
    ),
    bodyLarge: TextStyle(
      fontSize: AppFontSize.md,
      fontFamily: AppFontFamily.regular,
      color: AppColors.text,
    ),
    bodyMedium: TextStyle(
      fontSize: AppFontSize.sm,
      fontFamily: AppFontFamily.regular,
      color: AppColors.textLight,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: TextStyle(
        fontSize: AppFontSize.md,
        fontFamily: AppFontFamily.medium,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.gray300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(
      color: AppColors.gray500,
      fontFamily: AppFontFamily.regular,
    ),
  ),
);
