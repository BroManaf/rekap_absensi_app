import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:excel/excel.dart';
import '../models/department.dart';
import '../models/employee.dart';
import '../models/attendance_record.dart';
import '../models/attendance_summary.dart';

class AttendanceService {
  /// Parse time string (HH:MM or H:MM) to minutes since midnight
  /// 
  /// TODO: Remove debug logging after validating the fix with actual Excel data
  static int? parseTimeToMinutes(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) {
      if (kDebugMode) {
        print('[DEBUG] parseTimeToMinutes: null or empty input');
      }
      return null;
    }
    
    try {
      final cleanStr = timeStr.trim();
      if (kDebugMode) {
        print('[DEBUG] parseTimeToMinutes: parsing "$cleanStr"');
      }
      
      final parts = cleanStr.split(':');
      if (parts.length != 2) {
        if (kDebugMode) {
          print('[DEBUG] parseTimeToMinutes: invalid format (no colon), parts=$parts');
        }
        return null;
      }
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        if (kDebugMode) {
          print('[DEBUG] parseTimeToMinutes: out of range hour=$hour, minute=$minute');
        }
        return null;
      }
      
      final result = hour * 60 + minute;
      if (kDebugMode) {
        print('[DEBUG] parseTimeToMinutes: result=$result minutes ($hour:$minute)');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('[DEBUG] parseTimeToMinutes: exception parsing "$timeStr": $e');
      }
      return null;
    }
  }

  /// Calculate late time in minutes
  static int calculateLateness(int actualArrival, TimeOfDay departmentStartTime) {
    final departmentStart = departmentStartTime.toMinutes();
    
    if (actualArrival > departmentStart) {
      return actualArrival - departmentStart;
    }
    
    return 0;
  }

  /// Calculate work duration considering department start time and shifts
  static int calculateWorkDuration(
    int checkInTime,
    int checkOutTime,
    TimeOfDay departmentStartTime,
  ) {
    // If employee arrives before department time, start counting from department time
    final effectiveStart = checkInTime < departmentStartTime.toMinutes() 
        ? departmentStartTime.toMinutes() 
        : checkInTime;
    
    // Duration is from effective start to checkout
    if (checkOutTime > effectiveStart) {
      return checkOutTime - effectiveStart;
    }
    
    return 0;
  }

  /// Process a single day's attendance record
  /// 
  /// TODO: Remove debug logging after validating the fix with actual Excel data
  static Map<String, int> processDailyAttendance(
    AttendanceRecord record,
    Department department,
  ) {
    if (kDebugMode) {
      print('[DEBUG] processDailyAttendance: date=${record.date}, dept=${department.name}');
      print('[DEBUG]   jamMasukPagi="${record.jamMasukPagi}"');
      print('[DEBUG]   jamKeluarPagi="${record.jamKeluarPagi}"');
      print('[DEBUG]   jamMasukSiang="${record.jamMasukSiang}"');
      print('[DEBUG]   jamKeluarSiang="${record.jamKeluarSiang}"');
      print('[DEBUG]   jamMasukLembur="${record.jamMasukLembur}"');
      print('[DEBUG]   jamKeluarLembur="${record.jamKeluarLembur}"');
    }
    
    int dailyMasuk = 0;
    int dailyTelat = 0;

    // Find first check-in and last check-out for the day
    int? firstCheckIn;
    int? lastCheckOut;

    // Collect all check-in times
    final masukPagi = parseTimeToMinutes(record.jamMasukPagi);
    final masukSiang = parseTimeToMinutes(record.jamMasukSiang);
    final masukLembur = parseTimeToMinutes(record.jamMasukLembur);

    // Collect all check-out times
    final keluarPagi = parseTimeToMinutes(record.jamKeluarPagi);
    final keluarSiang = parseTimeToMinutes(record.jamKeluarSiang);
    final keluarLembur = parseTimeToMinutes(record.jamKeluarLembur);

    if (kDebugMode) {
      print('[DEBUG]   Parsed: masukPagi=$masukPagi, masukSiang=$masukSiang, masukLembur=$masukLembur');
      print('[DEBUG]   Parsed: keluarPagi=$keluarPagi, keluarSiang=$keluarSiang, keluarLembur=$keluarLembur');
    }

    // Determine first check-in
    if (masukPagi != null) {
      firstCheckIn = masukPagi;
    } else if (masukSiang != null) {
      firstCheckIn = masukSiang;
    } else if (masukLembur != null) {
      firstCheckIn = masukLembur;
    }

    // Determine last check-out
    if (keluarLembur != null) {
      lastCheckOut = keluarLembur;
    } else if (keluarSiang != null) {
      lastCheckOut = keluarSiang;
    } else if (keluarPagi != null) {
      lastCheckOut = keluarPagi;
    }

    if (kDebugMode) {
      print('[DEBUG]   firstCheckIn=$firstCheckIn, lastCheckOut=$lastCheckOut');
    }

    // Calculate lateness if there's a check-in
    if (firstCheckIn != null) {
      dailyTelat = calculateLateness(firstCheckIn, department.jamMasuk);
      if (kDebugMode) {
        print('[DEBUG]   dailyTelat=$dailyTelat minutes');
      }
    }

    // Calculate work duration if there's both check-in and check-out
    if (firstCheckIn != null && lastCheckOut != null) {
      dailyMasuk = calculateWorkDuration(firstCheckIn, lastCheckOut, department.jamMasuk);
      if (kDebugMode) {
        print('[DEBUG]   dailyMasuk=$dailyMasuk minutes');
      }
    }

    if (kDebugMode) {
      print('[DEBUG]   Result: masuk=$dailyMasuk, telat=$dailyTelat');
    }
    return {
      'masuk': dailyMasuk,
      'telat': dailyTelat,
    };
  }

  /// Calculate attendance summary for an employee across all records
  /// 
  /// TODO: Remove debug logging after validating the fix with actual Excel data
  static AttendanceSummary calculateSummary(
    Employee employee,
    List<AttendanceRecord> records,
  ) {
    if (kDebugMode) {
      print('[DEBUG] calculateSummary: employee=${employee.name}, records=${records.length}');
    }
    int totalMasuk = 0;
    int totalTelat = 0;

    for (var record in records) {
      if (record.hasData) {
        final daily = processDailyAttendance(record, employee.department);
        totalMasuk += daily['masuk'] ?? 0;
        totalTelat += daily['telat'] ?? 0;
      }
    }

    if (kDebugMode) {
      print('[DEBUG] calculateSummary: FINAL totalMasuk=$totalMasuk, totalTelat=$totalTelat');
    }
    return AttendanceSummary(
      employee: employee,
      totalMasukMinutes: totalMasuk,
      totalTelatMinutes: totalTelat,
    );
  }

  /// Parse Excel file and extract attendance data
  static Future<List<AttendanceSummary>> parseExcelFile(String filePath) async {
    // This will be implemented in the screen
    return [];
  }
}
