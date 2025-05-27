import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget buildPasswordField({
  required TextEditingController controller,
  required TextTheme textTheme,
  required String label,
  required bool showPassword,
  required void Function() onPressed,
  required String? Function(dynamic value) validator,
}) {
  return TextFormField(
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: AppFontFamily.regular,
    ),
    controller: controller,
    obscureText: !showPassword,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      prefixIcon: const Icon(Icons.lock_outline),
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      suffixIcon: IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey[600],
        ),
        onPressed: onPressed,
      ),
    ),
    validator: validator,
  );
}
