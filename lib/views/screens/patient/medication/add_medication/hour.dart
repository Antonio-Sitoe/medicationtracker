import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget hoursContainer(times, onPick, onRemove, onAdd, String errorMessage) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Horários",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 8),
      ...List.generate(times.length, (index) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onPick(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    times[index],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
            if (times.length > 1)
              IconButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                icon: const Icon(
                  Icons.remove_circle,
                  color: AppColors.secondaryDark,
                  size: 40,
                ),
                onPressed: () => onRemove(index),
              ),
          ],
        );
      }),
      if (errorMessage.isNotEmpty)
        Text(
          errorMessage,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.red, fontSize: 10),
        ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            foregroundColor: Colors.black87,
            // side: const BorderSide(color: AppColors.gray300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 16),
              Icon(Icons.add, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Adicionar Horario',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
