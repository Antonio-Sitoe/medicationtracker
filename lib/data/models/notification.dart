import 'package:flutter/material.dart';

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final TimeOfDay time;
  final List<int> days;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.days,
  });
}
