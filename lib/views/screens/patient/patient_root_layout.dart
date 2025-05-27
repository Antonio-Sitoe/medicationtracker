import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

class PatientRootLayout extends StatefulWidget {
  final Widget child;

  const PatientRootLayout({super.key, required this.child});

  @override
  State<PatientRootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<PatientRootLayout> {
  int _selectedIndex = 0;

  static const List<String> routes = [
    '/patient-tabs/home',
    '/patient-tabs/medications',
    '/patient-tabs/history',
    '/patient-tabs/settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue, // Active tab color
        unselectedItemColor: Colors.grey[600], // Inactive tab color
        selectedLabelStyle: TextStyle(
          fontFamily: AppFontFamily.regular,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFontFamily.regular,
          fontSize: 10,
        ),
        elevation: 8,
        iconSize: 24,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
