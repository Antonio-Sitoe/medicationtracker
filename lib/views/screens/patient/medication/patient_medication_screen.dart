import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

class PatientMedicationScreen extends StatelessWidget {
  const PatientMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 22),
          child: Column(
            children: [
              _MedicationHeader(context),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.left,
                  "Medicamentos activos (6)",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.regular,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _MedicationList(context),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            GoRouter.of(context).push('/patient-tabs/medications/add');
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

Widget _MedicationList(context) {
  return Expanded(
    flex: 1,
    child: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppFontSize.lg,
          horizontal: 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(8, (index) {
              return GestureDetector(
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push('/patient-tabs/medications/details');
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              color: AppColors.gray600,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Dosagem: 50G',
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                fontFamily: AppFontFamily.regular,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.gray600,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Diario',
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                fontFamily: AppFontFamily.regular,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: AppColors.gray600,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '22:00, 8:00',
                              style: TextStyle(
                                fontSize: AppFontSize.xs,
                                fontFamily: AppFontFamily.regular,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Parrasitamol",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontSize: AppFontSize.md,
                            fontFamily: AppFontFamily.regular,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary, // nova cor de background
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Activo",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontFamily: AppFontFamily.regular,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}

Widget _MedicationHeader(context) {
  final emailController = TextEditingController();
  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.left,
          "Medicamentos",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppFontSize.xl,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.regular,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: AppFontFamily.regular,
          ),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: 'Pesquisar medicamento...',
            labelStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.gray300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    ),
  );
}
