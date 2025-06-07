import 'package:flutter/material.dart';

Widget listHoursContainer(
  BuildContext context,
  selectedDays,
  weekDays,
  onSelected,
) {
  return Column(
    children: [
      Wrap(
        spacing: 8,
        children: List.generate(7, (index) {
          final selected = selectedDays.contains(index);
          return ChoiceChip(
            label: Text(weekDays[index]),
            selected: selected,
            onSelected: (_) => onSelected(index),
            selectedColor: Theme.of(context).colorScheme.primary,
          );
        }),
      ),
      const SizedBox(height: 16),
    ],
  );
}
