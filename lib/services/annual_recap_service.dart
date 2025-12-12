import 'package:flutter/foundation.dart' show debugPrint;
import '../models/annual_recap_data.dart';
import '../models/attendance_summary.dart';
import 'attendance_storage_service.dart';

class AnnualRecapService {
  /// Fetch annual recap data for all employees for a given year
  /// Returns a list of EmployeeAnnualData sorted by employee name
  static Future<List<EmployeeAnnualData>> fetchAnnualData(int year) async {
    try {
      // Use composite key (userId + name) to handle cases where multiple employees have same User ID
      // Map to store monthly data for each employee: key = "userId|name", value = map of monthly data
      final Map<String, Map<int, MonthlyData>> employeeMonthlyDataMap = {};
      // Map to store employee info: key = "userId|name", value = (userId, name, department)
      final Map<String, Map<String, String>> employeeInfoMap = {};

      debugPrint('[AnnualRecapService] Starting to fetch annual data for year $year');

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

            // Create composite key using userId and name to handle duplicate User IDs
            final compositeKey = '$userId|$name';

            debugPrint('[AnnualRecapService] Processing employee: $name (ID: $userId) for month $month');

            // Store employee info (use first occurrence)
            if (!employeeInfoMap.containsKey(compositeKey)) {
              employeeInfoMap[compositeKey] = {
                'userId': userId,
                'name': name,
                'department': department,
              };
              debugPrint('[AnnualRecapService] Registered new employee: $name (ID: $userId) with composite key: $compositeKey');
            }

            // Initialize monthly data map if not exists
            if (!employeeMonthlyDataMap.containsKey(compositeKey)) {
              employeeMonthlyDataMap[compositeKey] = {};
            }

            // Add monthly data
            employeeMonthlyDataMap[compositeKey]![month] = MonthlyData(
              totalMasukMinutes: summary.totalMasukMinutes,
              totalTelatMinutes: summary.totalTelatMinutes,
              totalLemburMinutes: summary.totalLemburMinutes,
              daysMasuk: summary.daysMasuk,
              daysTelat: summary.daysTelat,
              daysLembur: summary.daysLembur,
            );

            debugPrint('[AnnualRecapService] Added data for $name ($userId) in month $month: '
                'Masuk=${summary.totalMasukMinutes}min (${summary.totalMasukMinutes ~/ 60}h ${summary.totalMasukMinutes % 60}m) /${summary.daysMasuk}days, '
                'Telat=${summary.totalTelatMinutes}min (${summary.totalTelatMinutes ~/ 60}h ${summary.totalTelatMinutes % 60}m) /${summary.daysTelat}days, '
                'Lembur=${summary.totalLemburMinutes}min (${summary.totalLemburMinutes ~/ 60}h ${summary.totalLemburMinutes % 60}m) /${summary.daysLembur}days');
          }
        } else {
          debugPrint('[AnnualRecapService] Month $month: No data found');
        }
      }

      debugPrint('[AnnualRecapService] Total unique employees found: ${employeeInfoMap.length}');
      debugPrint('[AnnualRecapService] Employee list: ${employeeInfoMap.values.map((e) => "${e['name']} (${e['userId']})").join(", ")}');

      // Convert to list of EmployeeAnnualData
      final List<EmployeeAnnualData> result = [];
      for (var compositeKey in employeeMonthlyDataMap.keys) {
        final info = employeeInfoMap[compositeKey];
        if (info != null) {
          final employeeAnnualData = EmployeeAnnualData(
            userId: info['userId']!,
            name: info['name']!,
            department: info['department']!,
            monthlyData: employeeMonthlyDataMap[compositeKey]!,
          );
          result.add(employeeAnnualData);
          
          // Log summary for this employee
          final monthsWithData = employeeMonthlyDataMap[compositeKey]!.keys.toList()..sort();
          debugPrint('[AnnualRecapService] Employee ${info['name']} (${info['userId']}) has data for months: $monthsWithData');
        }
      }

      // Sort by name
      result.sort((a, b) => a.name.compareTo(b.name));

      debugPrint('[AnnualRecapService] Final result: ${result.length} employees for year $year');
      for (var emp in result) {
        debugPrint('[AnnualRecapService] - ${emp.name} (${emp.userId}): ${emp.monthlyData.length} months of data');
      }
      
      return result;
    } catch (e) {
      debugPrint('[AnnualRecapService] Error fetching annual data: $e');
      debugPrint('[AnnualRecapService] Stack trace: ${StackTrace.current}');
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
