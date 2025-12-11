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
      // Should count from 07:00 to 12:40 = 340 minutes regular, 0 overtime
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final checkIn = 405; // 06:45
      final checkOut = 760; // 12:40

      final duration = AttendanceService.calculateWorkDuration(
        checkIn,
        checkOut,
        departmentTime,
      );

      expect(duration['regular'], equals(340));
      expect(duration['overtime'], equals(0));
    });

    test('Calculate work duration with late arrival - Example 1', () {
      // Quarry employee: arrives at 09:00, leaves at 16:00
      // Should count from 09:00 to 16:00 = 420 minutes regular, 0 overtime
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final checkIn = 540; // 09:00
      final checkOut = 960; // 16:00

      final duration = AttendanceService.calculateWorkDuration(
        checkIn,
        checkOut,
        departmentTime,
      );

      expect(duration['regular'], equals(420));
      expect(duration['overtime'], equals(0));
    });

    test('Process daily attendance - Example 1 (Late arrival)', () {
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '09:00',
        jamKeluarSiang: '16:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(120)); // 2 hours late
      expect(result['masuk'], equals(420)); // 7 hours work (09:00 - 16:00)
      expect(result['lembur'], equals(0)); // No overtime
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
      expect(result['lembur'], equals(0)); // No overtime
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
      expect(result['masuk'], equals(480)); // 8 hours regular (08:00-16:00)
      expect(result['lembur'], equals(60)); // 1 hour overtime (17:00-17:00 actual, but counted from 17:00)
    });

    test('Process daily attendance - With overtime (NEW LOGIC)', () {
      // NEW: jamMasukLembur now represents the final clock-out time
      // Staff dept: clock in at 07:00, clock out at 21:00
      // Regular: 07:00 to 16:00 = 9 hours (540 min)
      // Gap: 16:00 to 17:00 = NOT COUNTED
      // Overtime: 17:00 to 21:00 = 4 hours (240 min)
      final department = Department.fromString('Staff');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamMasukLembur: '21:00', // This is now the final clock-out time
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness
      expect(result['masuk'], equals(540)); // 9 hours regular
      expect(result['lembur'], equals(240)); // 4 hours overtime
    });

    test('Process daily attendance - Quarry employee with overtime (Example from problem statement)', () {
      // Example from problem statement:
      // Quarry employee: clock in at 08:00, clock out at 20:00
      // Expected: LamaTelat = 1 hour (60 min), LamaMasuk = 8 hours (480 min), LamaLembur = 3 hours (180 min)
      // Breakdown:
      // - Regular hours: 08:00 to 16:00 = 8 hours (480 min)
      // - Gap: 16:00 to 17:00 = NOT COUNTED
      // - Overtime: 17:00 to 20:00 = 3 hours (180 min)
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '08:00',
        jamMasukLembur: '20:00', // Final clock-out time (used to be called "jam masuk lembur")
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(60)); // 1 hour late (08:00 - 07:00)
      expect(result['masuk'], equals(480)); // 8 hours regular (08:00-16:00)
      expect(result['lembur'], equals(180)); // 3 hours overtime (17:00-20:00)
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
          jamKeluarSiang: '16:00',
        ),
        AttendanceRecord(
          date: DateTime(2024, 1, 2),
          jamMasukPagi: '07:30',
          jamKeluarSiang: '16:00',
        ),
        AttendanceRecord(
          date: DateTime(2024, 1, 3),
          jamMasukPagi: '08:00',
          jamMasukLembur: '20:00', // Final clock-out with overtime
        ),
      ];

      final summary = AttendanceService.calculateSummary(employee, records);

      expect(summary.employee.userId, equals('EMP001'));
      expect(summary.totalTelatMinutes, equals(90)); // 0 + 30 + 60
      // Day 1: 07:00-16:00 = 540 min regular, 0 overtime
      // Day 2: 07:30-16:00 = 510 min regular, 0 overtime
      // Day 3: 08:00-16:00 = 480 min regular, 17:00-20:00 = 180 min overtime
      // Total regular: 540 + 510 + 480 = 1530 min
      // Total overtime: 0 + 0 + 180 = 180 min
      expect(summary.totalMasukMinutes, equals(1530));
      expect(summary.totalLemburMinutes, equals(180));
    });

    test('Process daily attendance - Checkout at exactly 16:00 (no overtime)', () {
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamKeluarSiang: '16:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0));
      expect(result['masuk'], equals(540)); // 9 hours (07:00-16:00)
      expect(result['lembur'], equals(0)); // No overtime
    });

    test('Process daily attendance - Checkout at 16:30 (between shifts)', () {
      // Checkout between 16:00 and 17:01 should count only up to 16:00
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamKeluarSiang: '16:30',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0));
      expect(result['masuk'], equals(540)); // 9 hours (07:00-16:00, gap not counted)
      expect(result['lembur'], equals(0)); // No overtime
    });

    test('Process daily attendance - Checkout at exactly 17:01 (overtime start)', () {
      // Checkout at 17:01 should count regular hours + 1 minute of overtime
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamMasukLembur: '17:01',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0));
      // Regular: 07:00-16:00 = 540 min
      // Overtime: 17:00-17:01 = 1 min
      expect(result['masuk'], equals(540));
      expect(result['lembur'], equals(1));
    });

    test('Process daily attendance - Checkout at exactly 17:00 (no overtime)', () {
      // Checkout at 17:00 exactly should NOT trigger overtime
      // Only regular hours counted up to 16:00
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamKeluarSiang: '17:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0));
      // Regular: 07:00-16:00 = 540 min
      // Gap: 16:00-17:00 not counted, and 17:00 is not overtime yet
      expect(result['masuk'], equals(540));
      expect(result['lembur'], equals(0));
    });

    test('Process daily attendance - Problem statement example (07:00-16:30, lembur at 20:00)', () {
      // Example from problem statement:
      // Quarry employee: clock in at 07:00, leaves at 16:30, has lembur data at 20:00
      // Expected: Total Telat = 0, Total Masuk = 9 hours (540 min), Total Lembur = 3 hours (180 min)
      // Note: jamMasukLembur (20:00) takes precedence as the final clock-out time
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '07:00',
        jamKeluarSiang: '16:30', // Intermediate checkout (ignored when jamMasukLembur is present)
        jamMasukLembur: '20:00', // Final clock-out time (takes precedence)
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness
      expect(result['masuk'], equals(540)); // 9 hours regular (07:00-16:00)
      expect(result['lembur'], equals(180)); // 3 hours overtime (17:00-20:00)
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

    test('Process daily attendance - Sunday (Min) simple case', () {
      // Sunday: All hours count as overtime
      // Quarry employee: clock in at 09:00, clock out at 16:00
      // Expected: Total Masuk = 0, Total Telat = 0, Total Lembur = 7 hours (420 min)
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 7), // Sunday
        dayOfWeek: 'Min',
        jamMasukPagi: '09:00',
        jamKeluarSiang: '16:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness on Sunday
      expect(result['masuk'], equals(0)); // No regular hours on Sunday
      expect(result['lembur'], equals(420)); // 7 hours overtime (09:00-16:00)
    });

    test('Process daily attendance - Sunday (Min) with overtime period', () {
      // Sunday: All hours count as overtime (including gap period logic)
      // Quarry employee: clock in at 09:00, clock out at 20:00
      // Expected: Total Masuk = 0, Total Telat = 0, Total Lembur = 10 hours
      // Breakdown: 09:00-16:00 (7h) + 17:00-20:00 (3h) = 10h total overtime
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 7), // Sunday
        dayOfWeek: 'Min',
        jamMasukPagi: '09:00',
        jamMasukLembur: '20:00', // Final clock-out
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness on Sunday
      expect(result['masuk'], equals(0)); // No regular hours on Sunday
      // 09:00-16:00 = 420 min, gap 16:00-17:00 not counted, 17:00-20:00 = 180 min
      // Total: 420 + 180 = 600 minutes (10 hours)
      expect(result['lembur'], equals(600));
    });

    test('Process daily attendance - Sunday (Min) respects department start time', () {
      // Sunday: Employee clocks in before department time
      // Quarry employee: clock in at 06:45, clock out at 16:00
      // Should count from 07:00 (department start time)
      // Expected: Total Masuk = 0, Total Telat = 0, Total Lembur = 9 hours (540 min)
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 7), // Sunday
        dayOfWeek: 'Min',
        jamMasukPagi: '06:45',
        jamKeluarSiang: '16:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(0)); // No lateness on Sunday
      expect(result['masuk'], equals(0)); // No regular hours on Sunday
      expect(result['lembur'], equals(540)); // 9 hours overtime (07:00-16:00)
    });

    test('Process daily attendance - Regular weekday (not Sunday)', () {
      // Monday: Regular calculation should apply
      final department = Department.fromString('Quarry');
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1), // Monday
        dayOfWeek: 'Sen',
        jamMasukPagi: '09:00',
        jamKeluarSiang: '16:00',
      );

      final result = AttendanceService.processDailyAttendance(record, department);

      expect(result['telat'], equals(120)); // 2 hours late
      expect(result['masuk'], equals(420)); // 7 hours regular (09:00-16:00)
      expect(result['lembur'], equals(0)); // No overtime
    });

    test('AttendanceRecord - isSunday and isSaturday helpers', () {
      final sundayRecord = AttendanceRecord(
        date: DateTime(2024, 1, 7),
        dayOfWeek: 'Min',
      );
      expect(sundayRecord.isSunday, isTrue);
      expect(sundayRecord.isSaturday, isFalse);

      final saturdayRecord = AttendanceRecord(
        date: DateTime(2024, 1, 6),
        dayOfWeek: 'Sab',
      );
      expect(saturdayRecord.isSunday, isFalse);
      expect(saturdayRecord.isSaturday, isTrue);

      final mondayRecord = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        dayOfWeek: 'Sen',
      );
      expect(mondayRecord.isSunday, isFalse);
      expect(mondayRecord.isSaturday, isFalse);
    });
  });
}
