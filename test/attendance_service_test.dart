import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/models/department.dart';
import 'package:rekap_absensi_app/models/employee.dart';
import 'package:rekap_absensi_app/models/attendance_record.dart';
import 'package:rekap_absensi_app/services/attendance_service.dart';

void main() {
  group('AttendanceService Tests', () {
    test('Parse time string to minutes', () {
      expect(AttendanceService.parseTimeToMinutes('07:00'), equals(420));
      expect(AttendanceService.parseTimeToMinutes('12:30'), equals(750));
      expect(AttendanceService.parseTimeToMinutes('18:00'), equals(1080));
      expect(AttendanceService.parseTimeToMinutes('23:59'), equals(1439));
      expect(AttendanceService.parseTimeToMinutes(null), isNull);
      expect(AttendanceService.parseTimeToMinutes(''), isNull);
      expect(AttendanceService.parseTimeToMinutes('invalid'), isNull);
    });

    test('Calculate lateness for on-time arrival', () {
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final arrivalTime = 420; // 07:00

      final lateness = AttendanceService.calculateLateness(
        arrivalTime,
        departmentTime,
      );

      expect(lateness, equals(0));
    });

    test('Calculate lateness for late arrival', () {
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final arrivalTime = 430; // 07:10

      final lateness = AttendanceService.calculateLateness(
        arrivalTime,
        departmentTime,
      );

      expect(lateness, equals(10));
    });

    test('Calculate lateness for early arrival', () {
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final arrivalTime = 405; // 06:45

      final lateness = AttendanceService.calculateLateness(
        arrivalTime,
        departmentTime,
      );

      expect(lateness, equals(0));
    });

    test('Calculate work duration with early arrival - Example 2', () {
      // Quarry employee: arrives at 06:45, leaves at 12:40
      // Should count from 07:00 to 12:40 = 340 minutes
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final checkIn = 405; // 06:45
      final checkOut = 760; // 12:40

      final duration = AttendanceService.calculateWorkDuration(
        checkIn,
        checkOut,
        departmentTime,
      );

      expect(duration, equals(340));
    });

    test('Calculate work duration with late arrival - Example 1', () {
      // Quarry employee: arrives at 09:00, leaves at 18:00
      // Should count from 09:00 to 18:00 = 540 minutes
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final checkIn = 540; // 09:00
      final checkOut = 1080; // 18:00

      final duration = AttendanceService.calculateWorkDuration(
        checkIn,
        checkOut,
        departmentTime,
      );

      expect(duration, equals(540));
    });

    test('Process daily attendance - Example 1 (Late arrival)', () {
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '09:00',
        jamKeluarSiang: '18:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(120)); // 2 hours late
      expect(result['masuk'], equals(540)); // 9 hours work
    });

    test('Process daily attendance - Example 2 (Early arrival)', () {
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '06:45',
        jamKeluarSiang: '12:40',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness
      expect(result['masuk'], equals(340)); // 5h 40m work
    });

    test('Process daily attendance - On time with afternoon shift', () {
      final department = Department.fromString('Office');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '08:00',
        jamKeluarPagi: '12:00',
        jamMasukSiang: '13:00',
        jamKeluarSiang: '17:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness
      expect(result['masuk'], equals(480)); // 8 hours total
    });

    test('Process daily attendance - With overtime', () {
      final department = Department.fromString('Staff');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamKeluarSiang: '17:00',
        jamMasukLembur: '18:00',
        jamKeluarLembur: '21:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness
      expect(result['masuk'], equals(780)); // 13 hours total (10h regular + 3h overtime)
    });

    test('Calculate summary for multiple days', () {
      final department = Department.fromString('Quarry');
      final employee = Employee(
        userId: 'EMP001',
        name: 'John Doe',
        department: department,
      );

      final records = [
        AttendanceRecord(
          date: DateTime(2024, 1, 1),
          jamMasukPagi: '07:00',
          jamKeluarSiang: '17:00',
        ),
        AttendanceRecord(
          date: DateTime(2024, 1, 2),
          jamMasukPagi: '07:30',
          jamKeluarSiang: '17:00',
        ),
        AttendanceRecord(
          date: DateTime(2024, 1, 3),
          jamMasukPagi: '08:00',
          jamKeluarSiang: '18:00',
        ),
      ];

      final summary = AttendanceService.calculateSummary(employee, records);

      expect(summary.employee.userId, equals('EMP001'));
      expect(summary.totalTelatMinutes, equals(90)); // 0 + 30 + 60
      expect(summary.totalMasukMinutes, equals(1800)); // 600 + 570 + 600
    });

    test('Department detection from string', () {
      expect(Department.fromString('Staff').name, equals('Staff'));
      expect(Department.fromString('staff').name, equals('Staff'));
      expect(Department.fromString('STAFF').name, equals('Staff'));
      expect(Department.fromString('Quarry').name, equals('Quarry'));
      expect(Department.fromString('Office').name, equals('Office'));
      expect(Department.fromString('Intern').name, equals('Intern'));
      expect(Department.fromString('Beban').name, equals('Beban'));
      expect(Department.fromString('Unknown').name, equals('Staff')); // Default
    });

    test('Department work hours', () {
      final staff = Department.fromString('Staff');
      expect(staff.jamMasuk.hour, equals(7));
      expect(staff.jamMasuk.minute, equals(0));

      final office = Department.fromString('Office');
      expect(office.jamMasuk.hour, equals(8));
      expect(office.jamMasuk.minute, equals(0));

      final intern = Department.fromString('Intern');
      expect(intern.jamMasuk.hour, equals(9));
      expect(intern.jamMasuk.minute, equals(0));
    });
  });
}
