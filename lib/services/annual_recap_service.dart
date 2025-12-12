import 'package:flutter/foundation.dart' show debugPrint;
import '../models/annual_recap_data.dart';
import '../models/attendance_summary.dart';
import 'attendance_storage_service.dart';

class AnnualRecapService {
  /// Fetch annual recap data for all employees for a given year
  /// Returns a list of EmployeeAnnualData sorted by employee name
  static Future<List<EmployeeAnnualData>> fetchAnnualData(int year) async {
    try {
      // Map to store monthly data for each employee: key = userId, value = map of monthly data
      final Map<String, Map<int, MonthlyData>> employeeMonthlyDataMap = {};
      // Map to store employee info: key = userId, value = (name, department)
      final Map<String, Map<String, String>> employeeInfoMap = {};

      // Fetch data for each month (1-12)
      for (int month = 1; month <= 12; month++) {
        final summaries = await AttendanceStorageService.loadAttendanceData(
          year: year,
          month: month,
        );

        if (summaries != null && summaries.isNotEmpty) {
          debugPrint('[AnnualRecapService] Month $month: Found ${summaries.length} employees');
          
          for (var summary in summaries) {
            final userId = summary.employee.userId;
            final name = summary.employee.name;
            final department = summary.employee.department.name;

            // Store employee info (use first occurrence)
            if (!employeeInfoMap.containsKey(userId)) {
              employeeInfoMap[userId] = {
                'name': name,
                'department': department,
              };
            }

            // Initialize monthly data map if not exists
            if (!employeeMonthlyDataMap.containsKey(userId)) {
              employeeMonthlyDataMap[userId] = {};
            }

            // Add monthly data
            employeeMonthlyDataMap[userId]![month] = MonthlyData(
              totalMasukMinutes: summary.totalMasukMinutes,
              totalTelatMinutes: summary.totalTelatMinutes,
              totalLemburMinutes: summary.totalLemburMinutes,
              daysMasuk: summary.daysMasuk,
              daysTelat: summary.daysTelat,
              daysLembur: summary.daysLembur,
            );

            debugPrint('[AnnualRecapService] Added data for $name ($userId) in month $month: '
                'Masuk=${summary.totalMasukMinutes}min/${summary.daysMasuk}days, '
                'Telat=${summary.totalTelatMinutes}min/${summary.daysTelat}days, '
                'Lembur=${summary.totalLemburMinutes}min/${summary.daysLembur}days');
          }
        }
      }

      // Convert to list of EmployeeAnnualData
      final List<EmployeeAnnualData> result = [];
      for (var userId in employeeMonthlyDataMap.keys) {
        final info = employeeInfoMap[userId]!;
        result.add(EmployeeAnnualData(
          userId: userId,
          name: info['name']!,
          department: info['department']!,
          monthlyData: employeeMonthlyDataMap[userId]!,
        ));
      }

      // Sort by name
      result.sort((a, b) => a.name.compareTo(b.name));

      debugPrint('[AnnualRecapService] Fetched data for ${result.length} employees for year $year');
      return result;
    } catch (e) {
      debugPrint('[AnnualRecapService] Error fetching annual data: $e');
      return [];
    }
  }

  /// Get list of all unique employees across all months of a year
  /// Returns a sorted list of employee user IDs
  static Future<List<String>> getEmployeeList(int year) async {
    try {
      final Set<String> employeeIds = {};

      for (int month = 1; month <= 12; month++) {
        final summaries = await AttendanceStorageService.loadAttendanceData(
          year: year,
          month: month,
        );

        if (summaries != null) {
          for (var summary in summaries) {
            employeeIds.add(summary.employee.userId);
          }
        }
      }

      final result = employeeIds.toList();
      result.sort();
      return result;
    } catch (e) {
      debugPrint('[AnnualRecapService] Error getting employee list: $e');
      return [];
    }
  }
}
