import 'employee.dart';

class AttendanceSummary {
  final Employee employee;
  final int totalMasukMinutes;
  final int totalTelatMinutes;

  AttendanceSummary({
    required this.employee,
    required this.totalMasukMinutes,
    required this.totalTelatMinutes,
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
}
