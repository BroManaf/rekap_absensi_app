import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_absensi_app/models/department.dart';
import 'package:rekap_absensi_app/models/employee.dart';
import 'package:rekap_absensi_app/models/attendance_record.dart';
import 'package:rekap_absensi_app/services/attendance_service.dart';

void main() {
  group('Excel Time Parsing Tests', () {
    test('Parse Excel decimal time to minutes - 09:45', () {
      // Excel stores 09:45 as 0.40625 (9.75 hours / 24 hours)
      // When converted to HH:MM format: "09:45"
      final result = AttendanceService.parseTimeToMinutes('09:45');
      expect(result, equals(585)); // 9*60 + 45 = 585 minutes
    });

    test('Parse Excel decimal time to minutes - 12:40', () {
      // Excel stores 12:40 as 0.527777... (12.666... hours / 24 hours)
      // When converted to HH:MM format: "12:40"
      final result = AttendanceService.parseTimeToMinutes('12:40');
      expect(result, equals(760)); // 12*60 + 40 = 760 minutes
    });

    test('Calculate lateness for Staff department - arrived at 09:45', () {
      // Staff department: jam masuk = 07:00
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final arrivalTime = 585; // 09:45 in minutes
      
      final lateness = AttendanceService.calculateLateness(
        arrivalTime,
        departmentTime,
      );
      
      // Expected: 09:45 - 07:00 = 165 minutes (2h 45m)
      expect(lateness, equals(165));
    });

    test('Calculate work duration - 09:45 to 12:40 for Staff', () {
      // Staff arrives at 09:45 (late), leaves at 12:40
      final departmentTime = TimeOfDay(hour: 7, minute: 0);
      final checkIn = 585; // 09:45
      final checkOut = 760; // 12:40
      
      final duration = AttendanceService.calculateWorkDuration(
        checkIn,
        checkOut,
        departmentTime,
      );
      
      // Expected: 12:40 - 09:45 = 175 minutes (2h 55m)
      expect(duration, equals(175));
    });

    test('Process daily attendance - Irfan Manaf scenario', () {
      // Based on problem statement:
      // - Name: Irfan Manaf
      // - UserID: 58
      // - Department: Staff (jam masuk: 07:00)
      // - Tanggal 1: Masuk 09:45, Keluar 12:40
      // - Expected: LamaTelat = 165 min, LamaMasuk = 175 min
      
      final department = Department.fromString('Staff');
      expect(department.jamMasuk.hour, equals(7));
      expect(department.jamMasuk.minute, equals(0));
      
      final record = AttendanceRecord(
        date: DateTime(2024, 1, 1),
        jamMasukPagi: '09:45',
        jamKeluarSiang: '12:40',
      );
      
      final result = AttendanceService.processDailyAttendance(record, department);
      
      expect(result['telat'], equals(165)); // 2h 45m late
      expect(result['masuk'], equals(175)); // 2h 55m work
    });

    test('Calculate summary for 31 days - Irfan Manaf pattern', () {
      // If employee works same pattern for 31 days:
      // - Daily: 165 min late, 175 min work
      // - Total (31 days): 5115 min late (85h 15m), 5425 min work (90h 25m)
      
      final department = Department.fromString('Staff');
      final employee = Employee(
        userId: '58',
        name: 'Irfan Manaf',
        department: department,
      );
      
      // Create 31 days of the same attendance pattern
      final records = List.generate(31, (index) {
        return AttendanceRecord(
          date: DateTime(2024, 1, index + 1),
          jamMasukPagi: '09:45',
          jamKeluarSiang: '12:40',
        );
      });
      
      final summary = AttendanceService.calculateSummary(employee, records);
      
      expect(summary.totalTelatMinutes, equals(5115)); // 165 * 31 = 5115
      expect(summary.totalMasukMinutes, equals(5425)); // 175 * 31 = 5425
      
      // Verify formatted output
      expect(summary.totalTelatFormatted, equals('85h 15m'));
      expect(summary.totalMasukFormatted, equals('90h 25m'));
    });

    test('Verify Staff department definition', () {
      final staff = Department.fromString('Staff');
      expect(staff.name, equals('Staff'));
      expect(staff.jamMasuk.hour, equals(7));
      expect(staff.jamMasuk.minute, equals(0));
      expect(staff.jamKeluar.hour, equals(17));
      expect(staff.jamKeluar.minute, equals(0));
    });
  });
}
