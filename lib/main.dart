import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medicationtracker/core/constants/appTheme.dart';
import 'package:medicationtracker/core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(theme: appTheme, routerConfig: router);
  }
}
