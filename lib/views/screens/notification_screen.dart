// Flutter version of NotificationsScreen with pixel-perfect structure

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final String medicationId;
  final DateTime scheduledTime;
  bool read;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.medicationId,
    required this.scheduledTime,
    this.read = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> notificationsList;

  @override
  void initState() {
    super.initState();
    notificationsList = [
      NotificationItem(
        id: '1',
        type: 'medication',
        title: 'Hora do medicamento',
        message: 'Está na hora de tomar Losartana 50mg',
        medicationId: '1',
        scheduledTime: DateTime.parse('2025-02-20T08:00:00'),
      ),
      NotificationItem(
        id: '2',
        type: 'reminder',
        title: 'Medicamento não confirmado',
        message: 'Você ainda não confirmou se tomou Atorvastatina 20mg',
        medicationId: '2',
        scheduledTime: DateTime.parse('2025-02-20T07:00:00'),
        read: true,
      ),
      NotificationItem(
        id: '3',
        type: 'missed',
        title: 'Medicamento perdido',
        message: 'Você perdeu o horário do medicamento Metformina 850mg',
        medicationId: '3',
        scheduledTime: DateTime.parse('2025-02-19T22:00:00'),
        read: true,
      ),
    ];
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case 'reminder':
        return const Icon(Icons.access_time, color: Colors.amber);
      case 'missed':
        return const Icon(Icons.close, color: Colors.redAccent);
      default:
        return const Icon(Icons.notifications_active, color: Colors.deepPurple);
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat("HH:mm'h'", 'pt_BR').format(time);
  }

  void _handleNotificationTap(NotificationItem item) {
    if (item.type == 'medication' || item.type == 'reminder') {
      Navigator.pushNamed(
        context,
        '/medication-confirmation',
        arguments: item.medicationId,
      );
    }
    setState(() {
      item.read = true;
    });
  }

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
              child:
                  notificationsList.isEmpty
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
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notificationsList.length,
                        itemBuilder: (context, index) {
                          final item = notificationsList[index];
                          return GestureDetector(
                            onTap: () => _handleNotificationTap(item),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    item.read
                                        ? Colors.white
                                        : Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    item.read
                                        ? null
                                        : Border(
                                          left: BorderSide(
                                            width: 4,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
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
                                      child: _getNotificationIcon(item.type),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.message,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatTime(item.scheduledTime),
                                          style: const TextStyle(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!item.read)
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
          ],
        ),
      ),
    );
  }
}
