import 'employee.dart';

/// Represents monthly attendance data for an employee
class MonthlyData {
  final int month; // 1-12
  final int daysMasuk; // Number of days present
  final int daysTelat; // Number of days late
  final int daysLembur; // Number of days with overtime

  MonthlyData({
    required this.month,
    required this.daysMasuk,
    required this.daysTelat,
    required this.daysLembur,
  });

  bool get hasData => daysMasuk > 0 || daysTelat > 0 || daysLembur > 0;
}

/// Represents annual recap data for a single employee
class EmployeeAnnualRecap {
  final Employee employee;
  final int year;
  final Map<int, MonthlyData> monthlyData; // month (1-12) -> MonthlyData

  EmployeeAnnualRecap({
    required this.employee,
    required this.year,
    required this.monthlyData,
  });

  /// Get monthly data for a specific month (1-12)
  MonthlyData? getMonthData(int month) {
    return monthlyData[month];
  }

  /// Check if employee has any data for the year
  bool get hasAnyData => monthlyData.values.any((data) => data.hasData);
}
