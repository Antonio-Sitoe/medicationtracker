import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/views/widgets/_show_error_dialog.dart';
import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/medication/dosage.dart';
import 'package:medicationtracker/data/models/medication/frequency.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:provider/provider.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/dosage.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/frequency.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/hour.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/instructions.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/list_hours.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/name.dart';
import 'package:medicationtracker/views/screens/patient/medication/add_medication/select_date.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String errorHours = "";
  DosageUnit dosageUnit = DosageUnit.mg;
  String frequency = '1';
  List<String> times = ['08:00'];
  bool hasEndDate = false;
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  List<int> selectedDays = [];

  final weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void toggleDay(int index) {
    setState(() {
      if (selectedDays.contains(index)) {
        selectedDays.remove(index);
      } else {
        selectedDays.add(index);
      }
    });
  }

  void addTime() {
    setState(() {
      times.add('08:00');
    });
  }

  void removeTime(int index) {
    setState(() {
      times.removeAt(index);
    });
  }

  void handleChangeFrequency(String? value) {
    setState(() {
      frequency = value!;
      times.clear();

      switch (value) {
        case "1":
          times.add('08:00');
          break;
        case "2":
          times.add('08:00');
          times.add('12:00');
          break;
        case "3":
          times.add('08:00');
          times.add('12:00');
          times.add('20:00');
          break;
        case "4":
          times.add('08:00');
          times.add('12:00');
          times.add('20:00');
          times.add('22:00');
          break;
        case "specific_days":
          times.add('08:00');
          break;
        default:
          times.add('08:00');
          break;
      }
    });
  }

  Future<void> pickDate({
    required BuildContext context,
    required bool isStart,
  }) async {
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: isStart ? (startDate) : (endDate ?? DateTime.now()),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('pt', 'BR'),
      );

      if (picked != null) {
        setState(() {
          if (isStart) {
            startDate = picked;
          } else {
            endDate = picked;
          }
        });
      }
    } catch (error) {
      print('Erro ao selecionar data: $error');
    }
  }

  Future<void> pickTime(int index) async {
    final parts = times[index].split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formatted = picked.format(context);
      final newTime = TimeOfDay(hour: picked.hour, minute: picked.minute);

      setState(() {
        times[index] = newTime.format(context);
      });
    }
  }

  Future<void> onSubmit() async {
    setState(() => errorHours = "");
    if (!_formKey.currentState!.validate()) return;
    if (times.toSet().length != times.length) {
      setState(() {
        errorHours = "Os horários não podem ser repetidos.";
      });
      return;
    }

    final medication = Provider.of<MedicationViewModel>(context, listen: false);
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final name = _nameController.text;
    final dosage = double.parse(_dosageController.text);
    final unit = dosageUnit;
    final instructions = _instructionsController.text;
    final userId = auth.currentUser?.uid ?? '';
    final uuid = Uuid();

    final newMedication = Medication(
      id: uuid.v4(),
      name: name,
      userId: userId,
      instructions: instructions,
      dosage: Dosage(quantity: dosage, unit: unit),
      frequency: Frequency(type: frequency, specificDays: selectedDays),
      scheduledTimes:
          times.map((time) {
            final parts = (time).split(":");
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }).toList(),
      startDate: startDate,
      endDate: endDate,
      receiveReminders: frequency == "as_needed" ? false : true,
    );

    print("MEDICAMENTO ${newMedication.toJson()}");
    try {
      await medication.create(newMedication);
      GoRouter.of(context).push(AppNamedRoutes.patientTabsMedications);
    } catch (e) {
      showErrorDialog(context, "Falha ao criar medicamento");
      debugPrint("Erro ao criar medicação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final medication = Provider.of<MedicationViewModel>(context, listen: true);
    final isLoading = medication.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text("Adicionar medicamento"), elevation: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              nameContainer(textTheme, _nameController),
              const SizedBox(height: 16),
              dosageContainer(
                textTheme,
                _dosageController,
                dosageUnit.name,
                (val) => setState(() => dosageUnit = val as DosageUnit),
              ),
              const SizedBox(height: 16),
              frequencyContainer(textTheme, frequency, handleChangeFrequency),
              const SizedBox(height: 16),
              hoursContainer(
                times,
                (index) => pickTime(index),
                (index) => removeTime(index),
                addTime,
                errorHours,
              ),
              const SizedBox(height: 16),
              if (frequency == 'specific_days')
                listHoursContainer(context, selectedDays, weekDays, toggleDay),

              selectDates(
                addTime: addTime,
                endDate: endDate,
                startDate: startDate,
                hasEndDate: hasEndDate,
                onPickDate: () => pickDate(context: context, isStart: true),
                onPickEnd: () => pickDate(context: context, isStart: false),
                onCheckBox:
                    (v) => setState(() {
                      hasEndDate = v ?? false;
                      if (!hasEndDate) endDate = null;
                    }),
              ),
              const SizedBox(height: 24),
              instructions(textTheme, _instructionsController),
              const SizedBox(height: 24),
              buildButton(
                context: context,
                label: 'Salvar Medicamento',
                onPressed: onSubmit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
