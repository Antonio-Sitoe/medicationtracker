import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/medication/status.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';
import 'package:provider/provider.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen({super.key});

  Future<void> onRemove(BuildContext context, String id) async {
    final vm = Provider.of<MedicationViewModel>(context, listen: false);
    await vm.remove(id);
    GoRouter.of(context).push(AppNamedRoutes.patientTabsMedications);
  }

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>;
    final medication = args['med'] as Medication;

    final dateFormat = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalhes do Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Detalhes do Medicamento",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.regular,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Card(
                elevation: 2,
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medication.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  overflow: TextOverflow.visible,
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  "${medication.dosage.quantity.toString()} ${medication.dosage.unit.name}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  medication.status == MedicationStatus.pendente
                                      ? AppColors.gray400
                                      : medication.status ==
                                          MedicationStatus.activo
                                      ? AppColors.primary
                                      : AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              medication.status.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _detailRow(
                        context,
                        LucideIcons.calendar,
                        'Frequência:',
                        medication.getFormattedFrequency(),
                      ),
                      if (medication.scheduledTimes.isNotEmpty)
                        _detailRow(
                          context,
                          LucideIcons.clock,
                          'Horários:',
                          medication.scheduledTimes
                              .map((t) => t.format(context))
                              .join(', '),
                        ),
                      _detailRow(
                        context,
                        LucideIcons.calendar,
                        'Início:',
                        dateFormat.format(medication.startDate),
                      ),
                      if (medication.endDate != null)
                        _detailRow(
                          context,
                          LucideIcons.calendar,
                          'Término:',
                          dateFormat.format(medication.endDate!),
                        ),
                      if (medication.instructions != null &&
                          medication.instructions!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.alertCircle,
                                    size: 20,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Instruções',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                medication.instructions!,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Editar'),
                      onPressed: () {
                        GoRouter.of(context).push(
                          AppNamedRoutes.patientTabsMedicationsAdd,
                          extra: {"med": medication},
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Remover'),
                      onPressed: () {
                        final parentContext = context;

                        showDialog(
                          context: parentContext,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Remover medicamento'),
                                content: const Text(
                                  'Tem certeza que deseja remover este medicamento? Esta ação não pode ser desfeita.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await onRemove(
                                        parentContext,
                                        medication.id,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Remover'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.gray600),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
