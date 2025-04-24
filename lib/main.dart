import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/appTheme.dart';
import 'package:medicationtracker/core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(theme: appTheme, routerConfig: router);
  }
}
