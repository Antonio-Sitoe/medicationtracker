import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/medication/status.dart';

Widget buildMedicationList(BuildContext context, List<Medication> meds) {
  return ListView.builder(
    itemCount: meds.length,
    itemBuilder: (context, index) {
      final med = meds[index];
      return GestureDetector(
        onTap: () {
          GoRouter.of(context).push(
            AppNamedRoutes.patientTabsMedicationsDetails,
            extra: {"med": med},
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, right: 5, left: 5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    med.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: AppFontSize.md,
                      fontFamily: AppFontFamily.regular,
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        med.status == MedicationStatus.pendente
                            ? AppColors.gray400
                            : med.status == MedicationStatus.activo
                            ? AppColors.primary
                            : AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    med.status.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: AppFontFamily.regular,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.pill, size: 20, color: AppColors.gray600),
                    const SizedBox(width: 4),
                    Text(
                      "Dosagem: ${med.dosage.quantity} ${med.dosage.unit.name}",
                      style: _subtitleStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 20,
                      color: AppColors.gray600,
                    ),
                    const SizedBox(width: 4),
                    Text(med.getFormattedFrequency(), style: _subtitleStyle()),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.clock, size: 20, color: AppColors.gray600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        med.scheduledTimes
                            .map((t) => t.format(context))
                            .join(', '),
                        style: _subtitleStyle(),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                (med.instructions == null ||
                            med.instructions!.trim().isEmpty) &&
                        !med.receiveReminders
                    ? const SizedBox.shrink()
                    : Column(
                      children: [
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (med.instructions != null)
                              Expanded(
                                child: Text(
                                  med.instructions ?? '',
                                  style: _subtitleStyle(),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            if (med.instructions != null &&
                                med.receiveReminders)
                              const SizedBox(width: 4),
                            if (med.receiveReminders)
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.gray200,
                                ),
                                child: Icon(
                                  LucideIcons.alarmClock,
                                  size: 20,
                                  color: AppColors.gray600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

TextStyle _subtitleStyle() {
  return TextStyle(
    fontSize: AppFontSize.xs,
    fontFamily: AppFontFamily.regular,
    color: AppColors.textLight,
  );
}
