import 'employee.dart';
import 'attendance_record.dart';

class AttendanceSummary {
  final Employee employee;
  final int totalMasukMinutes;
  final int totalTelatMinutes;
  final int totalLemburMinutes;
  final List<AttendanceRecord> records;

  AttendanceSummary({
    required this.employee,
    required this.totalMasukMinutes,
    required this.totalTelatMinutes,
    required this.totalLemburMinutes,
    required this.records,
  });

  String get totalMasukFormatted {
    final hours = totalMasukMinutes ~/ 60;
    final minutes = totalMasukMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get totalTelatFormatted {
    final hours = totalTelatMinutes ~/ 60;
    final minutes = totalTelatMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get totalLemburFormatted {
    final hours = totalLemburMinutes ~/ 60;
    final minutes = totalLemburMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
