import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/frequency.dart';
import 'package:medicationtracker/views/widgets/form/dropdown.dart';

Widget frequencyContainer(textTheme, frequency, onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Frequência",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 8),
      buildDropdown(
        value: frequency,
        items: FREQUENCY_OPTIONS,
        onChanged: onChanged,
        label: 'Frequência',
        textTheme: textTheme,
      ),
    ],
  );
}
