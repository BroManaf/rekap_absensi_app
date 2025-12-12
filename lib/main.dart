import 'package:flutter/material.dart';
import 'screens/attendance_screen.dart';
import 'screens/historis_absensi_screen.dart';
import 'widgets/sidebar.dart';
import 'widgets/historis_sidebar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rekap Absensi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        fontFamily: 'Inter',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AttendanceScreen(),
    const HistorisAbsensiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Main Sidebar
          Sidebar(
            selectedIndex: _selectedIndex,
            onMenuSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Secondary Sidebar (only show for Historis Absensi)
          if (_selectedIndex == 1)
            HistorisSidebar(
              onDateSelected: (year, month) {
                // Handle date selection if needed
                // You can pass this to HistorisAbsensiScreen through a callback
              },
            ),
          // Main Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}