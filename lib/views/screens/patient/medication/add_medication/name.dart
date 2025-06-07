import 'package:flutter/material.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';

Widget nameContainer(textTheme, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Nome do medicamento",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 8),
      buildInput(
        controller: controller,
        textTheme: textTheme,
        label: 'Digite o nome do medicamento',
      ),
    ],
  );
}
