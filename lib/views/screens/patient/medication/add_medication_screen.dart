import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';
import 'package:provider/provider.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  String dosageUnit = 'mg';
  String frequency = '1';
  List<String> times = ['08:00'];
  bool hasEndDate = false;
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  List<int> selectedDays = [];

  final dosageUnits = ['mg', 'ml', 'g', 'mcg', 'UI'];
  final frequencyOptions = {
    '1': '1x ao dia',
    '2': '2x ao dia',
    '3': '3x ao dia',
    '4': '4x ao dia',
    'as_needed': 'Quando necessário',
    'specific_days': 'Dias específicos',
  };
  final weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

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

  Future<void> pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : (endDate ?? DateTime.now()),
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR');
    final medication = Provider.of<MedicationViewModel>(context, listen: false);
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Medicamento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nome
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do medicamento',
              ),
            ),
            const SizedBox(height: 16),

            // Dosagem
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dosageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Dosagem'),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: dosageUnit,
                  onChanged: (value) => setState(() => dosageUnit = value!),
                  items:
                      dosageUnits
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Frequência
            DropdownButtonFormField<String>(
              value: frequency,
              onChanged: (val) => setState(() => frequency = val!),
              decoration: const InputDecoration(labelText: 'Frequência'),
              items:
                  frequencyOptions.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Horários',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(times.length, (index) {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickTime(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              times[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      if (times.length > 1)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => removeTime(index),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: addTime,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar horário'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Dias da semana (caso "specific_days")
            if (frequency == 'specific_days')
              Wrap(
                spacing: 8,
                children: List.generate(7, (index) {
                  final selected = selectedDays.contains(index);
                  return ChoiceChip(
                    label: Text(weekDays[index]),
                    selected: selected,
                    onSelected: (_) => toggleDay(index),
                    selectedColor: Theme.of(context).colorScheme.primary,
                  );
                }),
              ),
            const SizedBox(height: 16),

            // Período
            ListTile(
              onTap: () => pickDate(isStart: true),
              title: const Text('Data de início'),
              subtitle: Text(dateFormat.format(startDate)),
              leading: const Icon(Icons.calendar_today),
            ),
            if (hasEndDate)
              ListTile(
                onTap: () => pickDate(isStart: false),
                title: const Text('Data de término'),
                subtitle: Text(
                  endDate != null
                      ? dateFormat.format(endDate!)
                      : 'Selecione...',
                ),
                leading: const Icon(Icons.calendar_today_outlined),
              ),
            Row(
              children: [
                Checkbox(
                  value: hasEndDate,
                  onChanged:
                      (v) => setState(() {
                        hasEndDate = v ?? false;
                        if (!hasEndDate) endDate = null;
                      }),
                ),
                const Text('Definir data de término'),
              ],
            ),

            const SizedBox(height: 24),

            // Instruções
            TextField(
              controller: instructionsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Instruções (opcional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Botão salvar
            ElevatedButton(
              style: ButtonStyle(alignment: Alignment.topLeft),
              onPressed: () async {
                await medication.create(auth.currentUser!.uid.toString());
                // Aqui você pode salvar os dados ou chamar um Provider/Service
                // Navigator.pop(context);
              },
              child: const Text('Salvar Medicamento'),
            ),
          ],
        ),
      ),
    );
  }
}
