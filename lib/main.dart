import 'package:flutter/material.dart';
import 'screens/attendance_screen.dart';
import 'screens/historis_absensi_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/sidebar.dart';
import 'widgets/historis_sidebar.dart';
import 'services/database_service.dart';
import 'services/migration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.initialize();
  
  // Migrate old data if needed
  await MigrationService.migrateIfNeeded();
  
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
      home: const LoginScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
      },
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
  int? _selectedYear;
  int? _selectedMonth;
  final GlobalKey<HistorisAbsensiScreenState> _historisKey = GlobalKey();

  void _onDataSaved() {
    // Refresh historis screen when data is saved
    setState(() {
      _selectedIndex = 1; // Navigate to historis absensi
    });
  }

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
                setState(() {
                  _selectedYear = year;
                  _selectedMonth = month;
                });
                // Notify historis screen to load data
                _historisKey.currentState?.loadData(year, month);
              },
            ),
          // Main Content
          Expanded(
            child: _selectedIndex == 0
                ? AttendanceScreen(onDataSaved: _onDataSaved)
                : _selectedIndex == 1
                    ? HistorisAbsensiScreen(
                        key: _historisKey,
                        selectedYear: _selectedYear,
                        selectedMonth: _selectedMonth,
                      )
                    : const SettingsScreen(),
          ),
        ],
      ),
    );
  }
}