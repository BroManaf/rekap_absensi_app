import 'employee.dart';
import 'attendance_record.dart';

class AttendanceSummary {
  final Employee employee;
  final int totalMasukMinutes;
  final int totalTelatMinutes;
  final int totalLemburMinutes;
  final int daysMasuk; // Number of days with attendance (excluding Saturday and Sunday)
  final int daysTelat; // Number of days the employee was late
  final int daysLembur; // Number of days with overtime (including Sunday if applicable)
  final List<AttendanceRecord> records;

  AttendanceSummary({
    required this.employee,
    required this.totalMasukMinutes,
    required this.totalTelatMinutes,
    required this.totalLemburMinutes,
    required this.daysMasuk,
    required this.daysTelat,
    required this.daysLembur,
    required this.records,
  });

  String get totalMasukFormatted {
    final hours = totalMasukMinutes ~/ 60;
    final minutes = totalMasukMinutes % 60;
    return '${hours}h ${minutes}m /$daysMasuk';
  }

  String get totalTelatFormatted {
    final hours = totalTelatMinutes ~/ 60;
    final minutes = totalTelatMinutes % 60;
    return '${hours}h ${minutes}m /$daysTelat';
  }

  String get totalLemburFormatted {
    final hours = totalLemburMinutes ~/ 60;
    final minutes = totalLemburMinutes % 60;
    return '${hours}h ${minutes}m /$daysLembur';
  }

  String get totalLemburSimple {
    final hours = totalLemburMinutes ~/ 60;
    final minutes = totalLemburMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
