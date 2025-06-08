import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/medication/status.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';
import 'package:medicationtracker/views/screens/patient/medication/list/medication_list.dart';
import 'package:medicationtracker/views/widgets/skeleton_list.dart';
import 'package:provider/provider.dart';

class PatientMedicationScreen extends StatefulWidget {
  const PatientMedicationScreen({super.key});
  @override
  State<StatefulWidget> createState() => PatientState();
}

class PatientState extends State<PatientMedicationScreen> {
  List<Medication> medicationsList = [];
  bool isLoading = true;

  Future<void> getMedications() async {
    final medicationViewModel = Provider.of<MedicationViewModel>(
      context,
      listen: false,
    );
    final result = await medicationViewModel.findMany();
    if (!mounted) return;
    setState(() {
      medicationsList = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
          child: Column(
            children: [
              _MedicationHeader(context),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Medicamentos activos (${medicationsList.where((med) => med.status == MedicationStatus.activo).length})",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.regular,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    isLoading
                        ? skeletonList()
                        : buildMedicationList(context, medicationsList),
              ),
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
