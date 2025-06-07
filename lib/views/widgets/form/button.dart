import 'package:flutter/material.dart';

Widget buildButton({
  required BuildContext context,
  bool isLoading = false,
  required void Function() onPressed,
  required String label,
}) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
              : Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
    ),
  );
}
