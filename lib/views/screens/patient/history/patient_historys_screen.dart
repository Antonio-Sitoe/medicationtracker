import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicationtracker/data/models/reminder_with_medication.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:medicationtracker/views/widgets/skeleton_list.dart';
import 'package:provider/provider.dart';

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen({super.key});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  bool sortAscending = false;
  List<ReminderWithMedication> reminders = [];
  bool isLoading = true;

  Future<void> getAllReminders() async {
    final reminder = Provider.of<ReminderViewModel>(context, listen: false);
    final result = await reminder.findManyPastRemindersGroupedByDay();
    if (!mounted) return;
    setState(() {
      reminders = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child:
                  isLoading
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: skeletonList(),
                      )
                      : ListView(
                        padding: const EdgeInsets.all(16),
                        children: _buildReminderList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReminderList() {
    final sortedReminders = [...reminders];
    sortedReminders.sort((a, b) {
      final aDate = a.reminder.createdAt;
      final bDate = b.reminder.createdAt;
      return sortAscending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });

    return sortedReminders.map((r) {
      final time = r.reminder.scheduledTime;
      final formattedTime =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      final date = r.reminder.createdAt;
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      return Column(
        children: [
          _buildDateGroup(formattedDate, [
            _buildScheduleItem(
              formattedTime,
              r.medicationName,
              "${r.reminder.body}",
              r.reminder.actionTaken == "take"
                  ? Colors.green
                  : r.reminder.actionTaken == "dismissed"
                  ? Colors.red
                  : Colors.orange,
            ),
          ]),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Histórico",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _iconAction(
                Icons.insert_drive_file,
                onTap: () {
                  GoRouter.of(context).go('/patient-tabs/history/reports');
                },
              ),
              const SizedBox(width: 8),
              _iconAction(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                onTap: () {
                  setState(() {
                    sortAscending = !sortAscending;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconAction(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildDateGroup(String title, List<Widget> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.deepPurple,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
          ),
          child: Column(children: schedules),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(
    String time,
    String name,
    String dosage,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(dosage, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
