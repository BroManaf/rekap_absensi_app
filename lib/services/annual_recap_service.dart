import 'package:flutter/foundation.dart' show debugPrint;
import '../models/annual_recap_data.dart';
import '../models/attendance_summary.dart';
import 'attendance_storage_service.dart';

class AnnualRecapService {
  /// Fetch annual recap data for all employees for a given year
  /// Returns a list of EmployeeAnnualData sorted by employee name
  static Future<List<EmployeeAnnualData>> fetchAnnualData(int year) async {
    try {
      // Map to store employee data: key = userId, value = employee data
      final Map<String, EmployeeAnnualData> employeeDataMap = {};

      // Fetch data for each month (1-12)
      for (int month = 1; month <= 12; month++) {
        final summaries = await AttendanceStorageService.loadAttendanceData(
          year: year,
          month: month,
        );

        if (summaries != null && summaries.isNotEmpty) {
          for (var summary in summaries) {
            final userId = summary.employee.userId;

            // Create or update employee data
            if (!employeeDataMap.containsKey(userId)) {
              employeeDataMap[userId] = EmployeeAnnualData(
                userId: userId,
                name: summary.employee.name,
                department: summary.employee.department.name,
                monthlyData: {},
              );
            }

            // Add monthly data
            employeeDataMap[userId]!.monthlyData[month] = MonthlyData(
              totalMasukMinutes: summary.totalMasukMinutes,
              totalTelatMinutes: summary.totalTelatMinutes,
              totalLemburMinutes: summary.totalLemburMinutes,
              daysMasuk: summary.daysMasuk,
              daysTelat: summary.daysTelat,
              daysLembur: summary.daysLembur,
            );
          }
        }
      }

      // Convert map to list and sort by name
      final List<EmployeeAnnualData> result = employeeDataMap.values.toList();
      result.sort((a, b) => a.name.compareTo(b.name));

      debugPrint('[AnnualRecapService] Fetched data for ${result.length} employees for year $year');
      return result;
    } catch (e) {
      debugPrint('[AnnualRecapService] Error fetching annual data: $e');
      return [];
    }
  }

  /// Get list of all employees from a specific month
  /// Used to get the complete employee list when some months might be missing
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

      return employeeIds.toList()..sort();
    } catch (e) {
      debugPrint('[AnnualRecapService] Error getting employee list: $e');
      return [];
    }
  }
}
