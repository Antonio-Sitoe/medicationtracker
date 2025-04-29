import 'package:flutter/material.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_configuration_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_historys_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_home_screen.dart';
import 'package:medicationtracker/views/screens/PatientTabs_tabs/patient_medication_screen.dart';

class PatientRootLayout extends StatefulWidget {
  @override
  _RootLayoutState createState() => _RootLayoutState();
}

class _RootLayoutState extends State<PatientRootLayout> {
  int __selectedIndex = 0;

  final List<Widget> screens = [
    PatientHomeScreen(),
    PatientMedicationScreen(),
    PatientHistorysScreen(),
    PatientConfigurationScreen(),
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      __selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[__selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: __selectedIndex,
        onTap: _navigateBottomBar,
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
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
