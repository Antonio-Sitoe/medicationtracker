import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicationtracker/app_layout.dart';
import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/core/services/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a base de dados SQLite local (substitui o Firebase).
  await DatabaseHelper.instance.database;

  await initializeDateFormatting('pt_BR', null);
  await NotificationService().initialize();

  runApp(const AppLayout());
}
