import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/home/upcoming_medication_card.dart';
import 'package:provider/provider.dart';

class PatientHomeScreen extends StatelessWidget {
  double completionRate = 88.0;

  PatientHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _PatientHomeHeader(context),
                const SizedBox(height: 16),
                _PatientProgressBar(completionRate),
                const SizedBox(height: 24),
                _PatientTitle('Próximo medicamento'),
                const SizedBox(height: 24),
                UpcomingMedicationCard(
                  medicationName: 'Paracetamol',
                  dosage: '500mg',
                  scheduledTime: '08:00',
                  instructions: 'Tomar com água, após o café da manhã.',
                  onTake: () {},
                ),
                const SizedBox(height: 24),
                _PatientTitle('Medicamentos de hoje'),
                const SizedBox(height: 12),
                _PatientMedicationToday(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _PatientTitle(String title) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: AppFontFamily.regular,
      ),
    ),
  );
}

Widget _PatientProgressBar(completionRate) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progresso de hoje',
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontFamily: AppFontFamily.regular,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            Text(
              '${completionRate.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: completionRate / 100,
          backgroundColor: Colors.grey[300],
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        const Text(
          '2 de 5 medicamentos tomados',
          style: TextStyle(fontSize: AppFontSize.xs),
        ),
      ],
    ),
  );
}

Widget _PatientMedicationToday() {
  return Column(
    children: [
      ...List.generate(8, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Paracetamol',
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '500mg às 08:00',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: AppFontSize.xs,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                ),
                child: const Text(
                  'Tomar',
                  style: TextStyle(fontSize: AppFontSize.xs),
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}

Widget _PatientHomeHeader(context) {
  String capitalize(String text) => text[0].toUpperCase() + text.substring(1);
  final currentUser =
      Provider.of<AuthViewModel>(context, listen: false).currentUser;

  final data = capitalize(
    DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(DateTime.now()),
  );
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${currentUser?.email}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppFontSize.md,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            data,
            style: TextStyle(
              fontSize: AppFontSize.xs,
              fontFamily: AppFontFamily.regular,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
      Row(
        children: [
          IconButton(
            iconSize: 24.0,
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.gray100),
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_sharp),
                iconSize: 24.0,
                onPressed: () {
                  GoRouter.of(context).push('/notification-screen');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.gray100),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
