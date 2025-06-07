import 'package:flutter/material.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';

Widget instructions(textTheme, instructionsController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Instruções (opcional)",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 8),
      buildInput(
        controller: instructionsController,
        textTheme: textTheme,
        label: 'Digite instruções adicionais',
        maxLines: 4,
        validator: (value) => null,
      ),
    ],
  );
}
