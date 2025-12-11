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
  /// 
  /// NEW LOGIC:
  /// - Afternoon shift ends at 16:00
  /// - Overtime starts at 17:01 (17:00:01 in practice, 17*60+1 in minutes = 1021)
  /// - Time between 16:00 and 17:01 is not counted as work time
  /// - If checkout is after 17:01, split calculation:
  ///   * Regular hours: checkIn to 16:00 (960 minutes)
  ///   * Overtime hours: 17:00 to checkOut
  /// 
  /// Returns a Map with 'regular' and 'overtime' keys containing minutes
  static Map<String, int> calculateWorkDuration(
    int checkInTime,
    int checkOutTime,
    TimeOfDay departmentStartTime,
  ) {
    // Constants for shift boundaries
    const afternoonEndMinutes = 16 * 60; // 16:00 = 960 minutes
    const overtimeStartMinutes = 17 * 60 + 1; // 17:01 = 1021 minutes
    
    // If employee arrives before department time, start counting from department time
    final effectiveStart = checkInTime < departmentStartTime.toMinutes() 
        ? departmentStartTime.toMinutes() 
        : checkInTime;
    
    // Case 1: Checkout before or at 16:00 - simple calculation
    if (checkOutTime <= afternoonEndMinutes) {
      if (checkOutTime > effectiveStart) {
        return {'regular': checkOutTime - effectiveStart, 'overtime': 0};
      }
      return {'regular': 0, 'overtime': 0};
    }
    
    // Case 2: Checkout between 16:00 and 17:01 - count up to 16:00 only
    if (checkOutTime > afternoonEndMinutes && checkOutTime < overtimeStartMinutes) {
      if (afternoonEndMinutes > effectiveStart) {
        return {'regular': afternoonEndMinutes - effectiveStart, 'overtime': 0};
      }
      return {'regular': 0, 'overtime': 0};
    }
    
    // Case 3: Checkout at or after 17:01 - split calculation
    // Regular hours: effectiveStart to 16:00
    int regularHours = 0;
    if (afternoonEndMinutes > effectiveStart) {
      regularHours = afternoonEndMinutes - effectiveStart;
    }
    
    // Overtime hours: 17:01 to checkOut (calculated from 17:00 for simplicity)
    // Note: Overtime period starts at 17:01, but we use 17:00 (1020) as the base 
    // for calculation as per requirement: "lembur dihitung mulai dari jam 17:00"
    const overtimeBase = 17 * 60; // 17:00 = 1020 minutes
    int overtimeHours = 0;
    if (checkOutTime >= overtimeStartMinutes) {
      overtimeHours = checkOutTime - overtimeBase;
    }
    
    return {'regular': regularHours, 'overtime': overtimeHours};
  }

  /// Process a single day's attendance record
  /// 
  /// New logic as per requirements:
  /// - jamMasukLembur now represents the actual clock-out time (not overtime clock-in)
  /// - jamKeluarLembur is no longer used in calculations
  /// - Overtime starts from 17:01 onwards
  /// - Returns separate values for regular work time and overtime
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
      print('[DEBUG]   jamMasukLembur="${record.jamMasukLembur}" (NOW USED AS FINAL CLOCK-OUT)');
      print('[DEBUG]   jamKeluarLembur="${record.jamKeluarLembur}" (NO LONGER USED)');
    }
    
    int dailyMasuk = 0;
    int dailyTelat = 0;
    int dailyLembur = 0;

    // Find first check-in and last check-out for the day
    int? firstCheckIn;
    int? lastCheckOut;

    // Collect all check-in times
    final masukPagi = parseTimeToMinutes(record.jamMasukPagi);
    final masukSiang = parseTimeToMinutes(record.jamMasukSiang);
    
    // NEW: jamMasukLembur is now the final clock-out time (not a clock-in)
    final lemburAsCheckOut = parseTimeToMinutes(record.jamMasukLembur);

    // Collect all check-out times
    final keluarPagi = parseTimeToMinutes(record.jamKeluarPagi);
    final keluarSiang = parseTimeToMinutes(record.jamKeluarSiang);
    // jamKeluarLembur is no longer used

    if (kDebugMode) {
      print('[DEBUG]   Parsed: masukPagi=$masukPagi, masukSiang=$masukSiang');
      print('[DEBUG]   Parsed: keluarPagi=$keluarPagi, keluarSiang=$keluarSiang, lemburAsCheckOut=$lemburAsCheckOut');
    }

    // Determine first check-in (only from actual check-in times)
    if (masukPagi != null) {
      firstCheckIn = masukPagi;
    } else if (masukSiang != null) {
      firstCheckIn = masukSiang;
    }

    // Determine last check-out (prioritize lemburAsCheckOut as it's the final clock-out)
    if (lemburAsCheckOut != null) {
      lastCheckOut = lemburAsCheckOut;
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
      final duration = calculateWorkDuration(firstCheckIn, lastCheckOut, department.jamMasuk);
      dailyMasuk = duration['regular'] ?? 0;
      dailyLembur = duration['overtime'] ?? 0;
      if (kDebugMode) {
        print('[DEBUG]   dailyMasuk=$dailyMasuk minutes, dailyLembur=$dailyLembur minutes');
      }
    }

    if (kDebugMode) {
      print('[DEBUG]   Result: masuk=$dailyMasuk, telat=$dailyTelat, lembur=$dailyLembur');
    }
    return {
      'masuk': dailyMasuk,
      'telat': dailyTelat,
      'lembur': dailyLembur,
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
    int totalLembur = 0;

    for (var record in records) {
      if (record.hasData) {
        final daily = processDailyAttendance(record, employee.department);
        totalMasuk += daily['masuk'] ?? 0;
        totalTelat += daily['telat'] ?? 0;
        totalLembur += daily['lembur'] ?? 0;
      }
    }

    if (kDebugMode) {
      print('[DEBUG] calculateSummary: FINAL totalMasuk=$totalMasuk, totalTelat=$totalTelat, totalLembur=$totalLembur');
    }
    return AttendanceSummary(
      employee: employee,
      totalMasukMinutes: totalMasuk,
      totalTelatMinutes: totalTelat,
      totalLemburMinutes: totalLembur,
    );
  }

  /// Parse Excel file and extract attendance data
  static Future<List<AttendanceSummary>> parseExcelFile(String filePath) async {
    // This will be implemented in the screen
    return [];
  }
}
