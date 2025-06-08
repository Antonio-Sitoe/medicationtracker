import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medicationtracker/app_layout.dart';
import 'package:medicationtracker/core/services/notifications/notification_service.dart';
import 'core/services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR', null);
  await NotificationService().initialize();

  runApp(AppLayout());
}
