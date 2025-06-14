import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medicationtracker/core/routes/app_router.dart';
import 'package:medicationtracker/core/constants/appTheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:medicationtracker/viewModels/medication_view_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MedicationViewModel()),
        ChangeNotifierProvider(create: (_) => ReminderViewModel()),
        // ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: Builder(
        builder: (context) {
          final auth = Provider.of<AuthViewModel>(context, listen: true);
          final router = createRouter(auth);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            routerConfig: router,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('pt', 'BR')],
          );
        },
      ),
    );
  }
}
