import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget buildDropdown({
  required String? value,
  required List<Map<String, String>> items,
  required void Function(String?) onChanged,
  required String label,
  required TextTheme textTheme,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.gray300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
    items:
        items
            .map(
              (option) => DropdownMenuItem<String>(
                value: option['value'],
                child: Text(option['label']!),
              ),
            )
            .toList(),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, campo Obrigatório';
      }
      return null;
    },
  );
}
