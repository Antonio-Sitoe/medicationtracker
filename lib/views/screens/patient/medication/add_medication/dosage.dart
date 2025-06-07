import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/dosage.dart';
import 'package:medicationtracker/views/widgets/form/dropdown.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';

Widget dosageContainer(textTheme, controller, dosageUnit, onChange) {
  final List<DosageUnit> dosageUnits = DosageUnit.values;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Dosagem",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            flex: 7,
            child: buildInput(
              controller: controller,
              textTheme: textTheme,
              label: 'Digite a dosagem',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: buildDropdown(
              value: dosageUnit,
              items:
                  dosageUnits
                      .map((unit) => {'label': unit.name, 'value': unit.name})
                      .toList(),
              onChanged:
                  (val) => onChange(
                    DosageUnit.values.firstWhere((e) => e.name == val),
                  ),
              label: 'Unidade',
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    ],
  );
}
