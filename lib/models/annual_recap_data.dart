/// Model to hold monthly aggregated data for Annual Recap
class MonthlyData {
  final int totalMasukMinutes;
  final int totalTelatMinutes;
  final int totalLemburMinutes;
  final int daysMasuk;
  final int daysTelat;
  final int daysLembur;

  MonthlyData({
    required this.totalMasukMinutes,
    required this.totalTelatMinutes,
    required this.totalLemburMinutes,
    required this.daysMasuk,
    required this.daysTelat,
    required this.daysLembur,
  });

  String get masukFormatted {
    final hours = totalMasukMinutes ~/ 60;
    final minutes = totalMasukMinutes % 60;
    return '${hours}h ${minutes}m\n/$daysMasuk';
  }

  String get telatFormatted {
    final hours = totalTelatMinutes ~/ 60;
    final minutes = totalTelatMinutes % 60;
    return '${hours}h ${minutes}m\n/$daysTelat';
  }

  String get lemburFormatted {
    final hours = totalLemburMinutes ~/ 60;
    final minutes = totalLemburMinutes % 60;
    return '${hours}h ${minutes}m\n/$daysLembur';
  }

  bool get isEmpty =>
      totalMasukMinutes == 0 &&
      totalTelatMinutes == 0 &&
      totalLemburMinutes == 0 &&
      daysMasuk == 0 &&
      daysTelat == 0 &&
      daysLembur == 0;
}

/// Model to hold annual data for a single employee
class EmployeeAnnualData {
  final String userId;
  final String name;
  final String department;
  final Map<int, MonthlyData> monthlyData; // Key: month (1-12), Value: MonthlyData

  EmployeeAnnualData({
    required this.userId,
    required this.name,
    required this.department,
    required this.monthlyData,
  });

  /// Get data for a specific month (1-12)
  /// Returns empty MonthlyData if no data exists
  MonthlyData getMonthData(int month) {
    return monthlyData[month] ??
        MonthlyData(
          totalMasukMinutes: 0,
          totalTelatMinutes: 0,
          totalLemburMinutes: 0,
          daysMasuk: 0,
          daysTelat: 0,
          daysLembur: 0,
        );
  }
}
