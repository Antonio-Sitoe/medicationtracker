import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medicationtracker/data/models/reminder_with_medication.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<ReminderWithMedication> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vm = Provider.of<ReminderViewModel>(context, listen: false);
    final list = await vm.findManyPastRemindersGroupedByDay();
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Icon _icon(String? actionTaken) {
    switch (actionTaken) {
      case 'take':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'dismissed':
        return const Icon(Icons.close, color: Colors.redAccent);
      default:
        return const Icon(Icons.access_time, color: Colors.amber);
    }
  }

  String _statusLabel(String? actionTaken) {
    switch (actionTaken) {
      case 'take':
        return 'Confirmado';
      case 'dismissed':
        return 'Perdido';
      default:
        return 'Pendente';
    }
  }

  String _formatTime(DateTime time) =>
      DateFormat("dd/MM HH:mm'h'", 'pt_BR').format(time);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notificações',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.notifications_none,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma notificação no momento',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              final isPending = item.reminder.actionTaken == null;
                              return GestureDetector(
                                onTap: () {
                                  if (isPending) {
                                    GoRouter.of(context).push(
                                      '/medication-confirmation',
                                      extra: item.reminder,
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? Colors.deepPurple.shade50
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isPending
                                        ? const Border(
                                            left: BorderSide(
                                              width: 4,
                                              color: Colors.deepPurple,
                                            ),
                                          )
                                        : null,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: _icon(item.reminder.actionTaken),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.medicationName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.reminder.body,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${_statusLabel(item.reminder.actionTaken)} • '
                                              '${_formatTime(item.reminder.createdAt)}',
                                              style: const TextStyle(
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isPending)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.deepPurple,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
