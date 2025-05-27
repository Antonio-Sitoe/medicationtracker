import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget buildInputText(
  TextEditingController controller,
  TextTheme textTheme,
  String label,
) {
  return TextFormField(
    controller: controller,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: AppFontFamily.regular,
    ),
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      prefixIcon: const Icon(Icons.person_outline),
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, campo Obrigatório';
      }
      return null;
    },
    textCapitalization: TextCapitalization.words,
  );
}
