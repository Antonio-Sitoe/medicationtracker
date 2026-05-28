import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/data/models/medication/medication.dart';
import 'package:medicationtracker/data/models/reminder_with_medication.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:provider/provider.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  List<Medication> _medications = [];
  List<ReminderWithMedication> _todayReminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final medVm = Provider.of<MedicationViewModel>(context, listen: false);
    final remVm = Provider.of<ReminderViewModel>(context, listen: false);

    final meds = await medVm.findMany();
    final reminders = await remVm.findManyPastRemindersGroupedByDay();

    if (!mounted) return;

    final today = DateTime.now();
    final todayOnly = reminders.where((r) {
      final d = r.reminder.createdAt;
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }).toList();

    setState(() {
      _medications = meds;
      _todayReminders = todayOnly;
      _loading = false;
    });
  }

  double _completionRate() {
    if (_todayReminders.isEmpty) return 0.0;
    final taken = _todayReminders
        .where((r) => r.reminder.actionTaken == 'take')
        .length;
    return (taken / _todayReminders.length) * 100;
  }

  Medication? _nextMedication() {
    final actives = _medications.where((m) {
      return m.scheduledTimes.isNotEmpty;
    }).toList();
    if (actives.isEmpty) return null;

    final now = TimeOfDay.now();
    Medication? candidate;
    int? candidateMinutes;

    for (final med in actives) {
      for (final t in med.scheduledTimes) {
        final diff = (t.hour * 60 + t.minute) - (now.hour * 60 + now.minute);
        if (diff >= 0 && (candidateMinutes == null || diff < candidateMinutes)) {
          candidate = med;
          candidateMinutes = diff;
        }
      }
    }
    return candidate ?? actives.first;
  }

  @override
  Widget build(BuildContext context) {
    final completion = _completionRate();
    final next = _nextMedication();

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildProgress(completion),
                  const SizedBox(height: 24),
                  _title('Próximo medicamento'),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )
                  else if (next == null)
                    _emptyCard('Sem medicamentos agendados.')
                  else
                    _upcomingCard(next),
                  const SizedBox(height: 24),
                  _title('Medicamentos de hoje'),
                  const SizedBox(height: 12),
                  if (_loading)
                    const SizedBox.shrink()
                  else if (_medications.isEmpty)
                    _emptyCard('Ainda não cadastrou nenhum medicamento.')
                  else
                    _medicationList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String t) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AppFontFamily.regular,
        ),
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Text(text, style: const TextStyle(color: AppColors.textLight)),
    );
  }

  Widget _buildProgress(double rate) {
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
                '${rate.toStringAsFixed(0)}%',
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
            value: rate / 100,
            backgroundColor: Colors.grey[300],
            color: AppColors.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${_todayReminders.where((r) => r.reminder.actionTaken == "take").length} '
            'de ${_todayReminders.length} medicamentos tomados',
            style: const TextStyle(fontSize: AppFontSize.xs),
          ),
        ],
      ),
    );
  }

  Widget _upcomingCard(Medication med) {
    final time = med.scheduledTimes.isNotEmpty
        ? med.scheduledTimes.first.format(context)
        : '--:--';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Icon(Icons.medication, size: 28, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${med.dosage.quantity} ${med.dosage.unit.name} às $time',
                  style: const TextStyle(color: AppColors.textLight),
                ),
                if (med.instructions != null && med.instructions!.isNotEmpty)
                  Text(
                    med.instructions!,
                    style: const TextStyle(
                      fontSize: AppFontSize.xs,
                      color: AppColors.textLight,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _medicationList() {
    return Column(
      children: _medications.map((med) {
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
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '${med.dosage.quantity} ${med.dosage.unit.name} - '
                      '${med.scheduledTimes.map((t) => t.format(context)).join(", ")}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: AppFontSize.xs,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String capitalize(String text) =>
        text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
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
              'Olá, ${currentUser?.displayName ?? 'Usuário'}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.md,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              data,
              style: const TextStyle(
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
              onPressed: () {
                GoRouter.of(context).push('/patient-tabs/settings/profile');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.gray100),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_sharp),
                  iconSize: 24.0,
                  onPressed: () {
                    GoRouter.of(context).push('/notification-screen');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.gray100,
                    ),
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
}
