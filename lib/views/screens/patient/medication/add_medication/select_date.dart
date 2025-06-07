import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

Widget selectDates({
  addTime,
  hasEndDate,
  startDate,
  endDate,
  onPickDate,
  onPickEnd,
  onCheckBox,
}) {
  final dateFormat = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR');

  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: addTime,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: ListTile(
            onTap: onPickDate,
            title: const Text('Data de início'),
            subtitle: Text(dateFormat.format(startDate)),
            leading: const Icon(Icons.calendar_today),
          ),
        ),
      ),

      if (hasEndDate)
        Column(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cardBackground,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: ListTile(
                  onTap: onPickEnd,
                  title: const Text('Data de término'),
                  subtitle: Text(
                    endDate != null
                        ? dateFormat.format(endDate!)
                        : 'Selecione...',
                  ),
                  leading: const Icon(Icons.calendar_today_outlined),
                ),
              ),
            ),
          ],
        ),
      Row(
        children: [
          Checkbox(value: hasEndDate, onChanged: onCheckBox),
          const Text('Definir data de término'),
        ],
      ),
    ],
  );
}
