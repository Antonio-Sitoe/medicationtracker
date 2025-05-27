import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    String? routeName,
    int durationSeconds = 4,
  }) {
    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade600,
      duration: Duration(seconds: durationSeconds),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: () {
                  if (routeName != null) {
                    Navigator.pushNamed(context, routeName);
                  }
                  onActionPressed?.call();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              )
              : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
