import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget buildEmailField(
  TextEditingController controller,
  TextTheme textTheme,
  String label,
) {
  return TextFormField(
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: AppFontFamily.regular,
    ),
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      prefixIcon: const Icon(Icons.email_outlined),
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, digite seu e-mail';
      }
      if (!value.contains('@')) {
        return 'Digite um e-mail válido';
      }
      return null;
    },
    keyboardType: TextInputType.emailAddress,
    autocorrect: false,
  );
}
