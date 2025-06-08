import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:provider/provider.dart';

class MedicationConfirmationScreen extends StatefulWidget {
  const MedicationConfirmationScreen({super.key});

  @override
  State<MedicationConfirmationScreen> createState() =>
      _MedicationConfirmationScreenState();
}

class _MedicationConfirmationScreenState
    extends State<MedicationConfirmationScreen> {
  bool showNotes = false;
  String notes = '';
  Reminder? reminder;

  void handleConfirmation(bool take) async {
    if (reminder == null) return;

    final reminderVm = Provider.of<ReminderViewModel>(context, listen: false);

    await reminderVm.patch(
      reminder!.id,
      actionTaken: take ? "take" : "dismissed",
      respondedAt: DateTime.now(),
    );

    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;
    if (extra is Reminder) {
      setState(() {
        reminder = extra;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reminder == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Confirmar Medicamento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Time
                      Column(
                        children: [
                          Icon(LucideIcons.clock, color: Colors.blue[700]),
                          const SizedBox(height: 8),
                          Text(
                            "${reminder!.scheduledTime.hour}:${reminder!.scheduledTime.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Horário programado',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Medication Info
                      Column(
                        children: [
                          Text(
                            reminder!.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reminder!.body,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => handleConfirmation(true),
                              icon: const Icon(
                                LucideIcons.check,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Tomei',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => handleConfirmation(false),
                              icon: const Icon(
                                LucideIcons.x,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Não tomei',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Add Notes
                      TextButton.icon(
                        onPressed: () => setState(() => showNotes = !showNotes),
                        icon: const Icon(
                          LucideIcons.messageSquare,
                          color: Colors.blue,
                        ),
                        label: Text(
                          showNotes
                              ? 'Ocultar observações'
                              : 'Adicionar observações',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),

                      if (showNotes) ...[
                        const SizedBox(height: 8),
                        TextField(
                          minLines: 4,
                          maxLines: 6,
                          onChanged: (value) => notes = value,
                          decoration: InputDecoration(
                            hintText: 'Digite suas observações aqui...',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
