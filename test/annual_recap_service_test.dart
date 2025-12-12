import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/services/annual_recap_service.dart';
import 'package:rekap_absensi_app/services/attendance_storage_service.dart';
import 'package:rekap_absensi_app/services/database_service.dart';
import 'package:rekap_absensi_app/models/attendance_summary.dart';
import 'package:rekap_absensi_app/models/employee.dart';
import 'package:rekap_absensi_app/models/department.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI for tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('AnnualRecapService Tests', () {
    test('Get annual recap with no data', () async {
      final recaps = await AnnualRecapService.getAnnualRecap(2099);
      expect(recaps, isEmpty);
    });

    test('Get annual recap with sample data', () async {
      // Create sample employees
      final employee1 = Employee(
        userId: 'EMP001',
        name: 'Test Employee 1',
        department: Department.fromString('Dep A'),
      );

      final employee2 = Employee(
        userId: 'EMP002',
        name: 'Test Employee 2',
        department: Department.fromString('Dep B'),
      );

      // Create sample summaries for multiple months
      final summary1Jan = AttendanceSummary(
        employee: employee1,
        totalMasukMinutes: 9600, // 160 hours
        totalTelatMinutes: 120, // 2 hours
        totalLemburMinutes: 240, // 4 hours
        daysMasuk: 20,
        daysTelat: 3,
        daysLembur: 5,
        records: [],
      );

      final summary2Jan = AttendanceSummary(
        employee: employee2,
        totalMasukMinutes: 9000,
        totalTelatMinutes: 60,
        totalLemburMinutes: 180,
        daysMasuk: 18,
        daysTelat: 2,
        daysLembur: 4,
        records: [],
      );

      final summary1Feb = AttendanceSummary(
        employee: employee1,
        totalMasukMinutes: 8640,
        totalTelatMinutes: 180,
        totalLemburMinutes: 300,
        daysMasuk: 18,
        daysTelat: 4,
        daysLembur: 6,
        records: [],
      );

      // Save test data for January 2098
      await AttendanceStorageService.saveAttendanceData(
        year: 2098,
        month: 1,
        summaries: [summary1Jan, summary2Jan],
      );

      // Save test data for February 2098
      await AttendanceStorageService.saveAttendanceData(
        year: 2098,
        month: 2,
        summaries: [summary1Feb],
      );

      // Get annual recap
      final recaps = await AnnualRecapService.getAnnualRecap(2098);

      // Verify results
      expect(recaps.length, equals(2));

      // Check employee 1
      final recap1 = recaps.firstWhere((r) => r.employee.userId == 'EMP001');
      expect(recap1.employee.name, equals('Test Employee 1'));
      expect(recap1.year, equals(2098));
      expect(recap1.monthlyData.length, equals(2)); // Has data for 2 months

      // Check January data for employee 1
      final jan1 = recap1.getMonthData(1);
      expect(jan1, isNotNull);
      expect(jan1!.daysMasuk, equals(20));
      expect(jan1.daysTelat, equals(3));
      expect(jan1.daysLembur, equals(5));

      // Check February data for employee 1
      final feb1 = recap1.getMonthData(2);
      expect(feb1, isNotNull);
      expect(feb1!.daysMasuk, equals(18));
      expect(feb1.daysTelat, equals(4));
      expect(feb1.daysLembur, equals(6));

      // Check employee 2
      final recap2 = recaps.firstWhere((r) => r.employee.userId == 'EMP002');
      expect(recap2.employee.name, equals('Test Employee 2'));
      expect(recap2.monthlyData.length, equals(1)); // Has data for 1 month

      // Check January data for employee 2
      final jan2 = recap2.getMonthData(1);
      expect(jan2, isNotNull);
      expect(jan2!.daysMasuk, equals(18));
      expect(jan2.daysTelat, equals(2));
      expect(jan2.daysLembur, equals(4));

      // Check that employee 2 has no February data
      final feb2 = recap2.getMonthData(2);
      expect(feb2, isNull);

      // Clean up test data
      await DatabaseService.deleteData('2098-01');
      await DatabaseService.deleteData('2098-02');
    });

    test('Get employee annual recap', () async {
      final employee = Employee(
        userId: 'EMP003',
        name: 'Test Employee 3',
        department: Department.fromString('Dep C'),
      );

      final summary = AttendanceSummary(
        employee: employee,
        totalMasukMinutes: 9600,
        totalTelatMinutes: 120,
        totalLemburMinutes: 240,
        daysMasuk: 20,
        daysTelat: 3,
        daysLembur: 5,
        records: [],
      );

      // Save test data
      await AttendanceStorageService.saveAttendanceData(
        year: 2097,
        month: 3,
        summaries: [summary],
      );

      // Get employee recap
      final recap = await AnnualRecapService.getEmployeeAnnualRecap('EMP003', 2097);

      // Verify results
      expect(recap, isNotNull);
      expect(recap!.employee.userId, equals('EMP003'));
      expect(recap.year, equals(2097));
      expect(recap.monthlyData.length, equals(1));

      final mar = recap.getMonthData(3);
      expect(mar, isNotNull);
      expect(mar!.daysMasuk, equals(20));

      // Clean up
      await DatabaseService.deleteData('2097-03');
    });

    test('Get available years', () async {
      // Create sample data for different years
      final employee = Employee(
        userId: 'EMP004',
        name: 'Test Employee 4',
        department: Department.fromString('Dep D'),
      );

      final summary = AttendanceSummary(
        employee: employee,
        totalMasukMinutes: 9600,
        totalTelatMinutes: 0,
        totalLemburMinutes: 0,
        daysMasuk: 20,
        daysTelat: 0,
        daysLembur: 0,
        records: [],
      );

      // Save data for different years
      await AttendanceStorageService.saveAttendanceData(
        year: 2096,
        month: 1,
        summaries: [summary],
      );

      await AttendanceStorageService.saveAttendanceData(
        year: 2095,
        month: 6,
        summaries: [summary],
      );

      // Get available years
      final years = await AnnualRecapService.getAvailableYears();

      // Verify results
      expect(years.contains(2096), isTrue);
      expect(years.contains(2095), isTrue);
      
      // Years should be sorted descending
      final index2096 = years.indexOf(2096);
      final index2095 = years.indexOf(2095);
      expect(index2096 < index2095, isTrue);

      // Clean up
      await DatabaseService.deleteData('2096-01');
      await DatabaseService.deleteData('2095-06');
    });
  });
}
