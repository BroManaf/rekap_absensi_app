import 'package:flutter/foundation.dart';
import '../models/annual_recap.dart';
import '../models/employee.dart';
import '../models/attendance_summary.dart';
import 'attendance_storage_service.dart';

class AnnualRecapService {
  /// Get annual recap data for all employees for a specific year
  /// 
  /// This aggregates data from all 12 months of attendance records
  /// Returns a list of EmployeeAnnualRecap with monthly attendance counts
  static Future<List<EmployeeAnnualRecap>> getAnnualRecap(int year) async {
    try {
      // Map to store employee data: userId -> EmployeeAnnualRecap
      final Map<String, EmployeeAnnualRecap> employeeRecaps = {};

      // Load data for all 12 months
      for (int month = 1; month <= 12; month++) {
        final summaries = await AttendanceStorageService.loadAttendanceData(
          year: year,
          month: month,
        );

        if (summaries == null || summaries.isEmpty) {
          continue;
        }

        // Process each employee's summary for this month
        for (var summary in summaries) {
          final userId = summary.employee.userId;

          // Create or update employee recap
          if (!employeeRecaps.containsKey(userId)) {
            employeeRecaps[userId] = EmployeeAnnualRecap(
              employee: summary.employee,
              year: year,
              monthlyData: {},
            );
          }

          // Add monthly data
          employeeRecaps[userId]!.monthlyData[month] = MonthlyData(
            month: month,
            daysMasuk: summary.daysMasuk,
            daysTelat: summary.daysTelat,
            daysLembur: summary.daysLembur,
          );
        }
      }

      // Convert map to list and sort by employee name
      final recapList = employeeRecaps.values.toList();
      recapList.sort((a, b) => a.employee.name.compareTo(b.employee.name));

      if (kDebugMode) {
        debugPrint('[AnnualRecapService] Loaded annual recap for $year: ${recapList.length} employees');
      }

      return recapList;
    } catch (e) {
      debugPrint('Error loading annual recap: $e');
      return [];
    }
  }

  /// Get annual recap data for a single employee
  static Future<EmployeeAnnualRecap?> getEmployeeAnnualRecap(
    String userId,
    int year,
  ) async {
    try {
      Employee? employee;
      final Map<int, MonthlyData> monthlyData = {};

      // Load data for all 12 months
      for (int month = 1; month <= 12; month++) {
        final summaries = await AttendanceStorageService.loadAttendanceData(
          year: year,
          month: month,
        );

        if (summaries == null || summaries.isEmpty) {
          continue;
        }

        // Find this employee's summary
        final summary = summaries.where((s) => s.employee.userId == userId).firstOrNull;
        
        if (summary != null) {
          employee ??= summary.employee;
          
          monthlyData[month] = MonthlyData(
            month: month,
            daysMasuk: summary.daysMasuk,
            daysTelat: summary.daysTelat,
            daysLembur: summary.daysLembur,
          );
        }
      }

      if (employee == null) {
        return null;
      }

      return EmployeeAnnualRecap(
        employee: employee,
        year: year,
        monthlyData: monthlyData,
      );
    } catch (e) {
      debugPrint('Error loading employee annual recap: $e');
      return null;
    }
  }

  /// Get list of years that have data
  static Future<List<int>> getAvailableYears() async {
    try {
      final availableMonths = await AttendanceStorageService.getAvailableMonths();
      final years = availableMonths.map((m) => m['year']!).toSet().toList();
      years.sort((a, b) => b.compareTo(a)); // Sort descending
      return years;
    } catch (e) {
      debugPrint('Error getting available years: $e');
      return [];
    }
  }
}
