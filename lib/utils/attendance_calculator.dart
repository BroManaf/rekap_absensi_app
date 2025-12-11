import 'package:flutter/material.dart';

/// Result of attendance calculation
class AttendanceResult {
  final Duration lamaTelat;
  final Duration lamaMasuk;
  final Duration lamaLembur;
  final Duration total;

  AttendanceResult({
    required this.lamaTelat,
    required this.lamaMasuk,
    required this.lamaLembur,
    required this.total,
  });

  /// Format duration as "Xh Ym" string
  static String formatDuration(Duration duration) {
    if (duration.isNegative || duration.inSeconds == 0) return '0h 0m';
    
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}m';
  }

  String get lamaTelatFormatted => formatDuration(lamaTelat);
  String get lamaMasukFormatted => formatDuration(lamaMasuk);
  String get lamaLemburFormatted => formatDuration(lamaLembur);
  String get totalFormatted => formatDuration(total);

  @override
  String toString() {
    return 'AttendanceResult(telat: $lamaTelat, masuk: $lamaMasuk, lembur: $lamaLembur, total: $total)';
  }
}

/// Compute attendance times based on entry/exit times
/// 
/// Parameters:
/// - [masukPagi]: Morning entry time (required)
/// - [keluarSiang]: Afternoon exit time (optional)
/// - [masukLembur]: Overtime entry time, treated as final exit (optional)
/// - [shiftStart]: Shift start time (default: 07:00)
/// - [regularEnd]: Regular work end time (default: 16:00)
/// - [overtimeStart]: Overtime start time (default: 17:01)
/// - [overtimeEnd]: Overtime end time next day (default: 05:00)
AttendanceResult computeAttendance({
  required DateTime masukPagi,
  DateTime? keluarSiang,
  DateTime? masukLembur,
  TimeOfDay shiftStart = const TimeOfDay(hour: 7, minute: 0),
  TimeOfDay regularEnd = const TimeOfDay(hour: 16, minute: 0),
  TimeOfDay overtimeStart = const TimeOfDay(hour: 17, minute: 1),
  TimeOfDay overtimeEnd = const TimeOfDay(hour: 5, minute: 0),
}) {
  // Determine final exit time
  DateTime finalExit = masukLembur ?? keluarSiang ?? masukPagi;
  
  // Build DateTime for shift start on the same day as masukPagi
  DateTime shiftStartTime = DateTime(
    masukPagi.year,
    masukPagi.month,
    masukPagi.day,
    shiftStart.hour,
    shiftStart.minute,
  );
  
  // Build DateTime for regular end on the same day
  DateTime regularEndTime = DateTime(
    masukPagi.year,
    masukPagi.month,
    masukPagi.day,
    regularEnd.hour,
    regularEnd.minute,
  );
  
  // Calculate late time (LamaTelat)
  Duration lamaTelat = Duration.zero;
  if (masukPagi.isAfter(shiftStartTime)) {
    lamaTelat = masukPagi.difference(shiftStartTime);
  }
  
  // Calculate work time (LamaMasuk) - from masukPagi to regularEnd (16:00)
  Duration lamaMasuk = Duration.zero;
  
  // Ensure we don't calculate work time if entry is after regular end
  if (masukPagi.isAfter(regularEndTime)) {
    lamaMasuk = Duration.zero;
  } else if (finalExit.isAfter(regularEndTime)) {
    // If final exit is after regular end, count full regular work time
    lamaMasuk = regularEndTime.difference(masukPagi);
  } else {
    // If final exit is before regular end, count until final exit
    lamaMasuk = finalExit.difference(masukPagi);
  }
  
  // Ensure lamaMasuk is not negative
  if (lamaMasuk.isNegative) {
    lamaMasuk = Duration.zero;
  }
  
  // Calculate overtime (LamaLembur)
  // Overtime window: from 17:01 today to 05:00 next day
  DateTime overtimeStartTime = DateTime(
    masukPagi.year,
    masukPagi.month,
    masukPagi.day,
    overtimeStart.hour,
    overtimeStart.minute,
  );
  
  DateTime overtimeEndTime = DateTime(
    masukPagi.year,
    masukPagi.month,
    masukPagi.day + 1, // Next day
    overtimeEnd.hour,
    overtimeEnd.minute,
  );
  
  Duration lamaLembur = Duration.zero;
  
  // Check if finalExit is within overtime window
  if (finalExit.isAfter(overtimeStartTime)) {
    DateTime overtimeActualStart = overtimeStartTime;
    DateTime overtimeActualEnd = finalExit;
    
    // If final exit goes past midnight into next day
    if (overtimeActualEnd.isAfter(overtimeEndTime)) {
      overtimeActualEnd = overtimeEndTime;
    }
    
    lamaLembur = overtimeActualEnd.difference(overtimeActualStart);
    
    // Ensure non-negative
    if (lamaLembur.isNegative) {
      lamaLembur = Duration.zero;
    }
  }
  
  // Calculate total work time
  Duration total = lamaMasuk + lamaLembur;
  
  return AttendanceResult(
    lamaTelat: lamaTelat,
    lamaMasuk: lamaMasuk,
    lamaLembur: lamaLembur,
    total: total,
  );
}

/// Try to parse a time string in various formats
/// Returns DateTime with today's date if successful, null otherwise
DateTime? parseTimeString(String timeStr, DateTime referenceDate) {
  if (timeStr.isEmpty) return null;
  
  // Try various time formats
  List<RegExp> patterns = [
    // HH:mm or H:mm
    RegExp(r'^(\d{1,2}):(\d{2})$'),
    // HH:mm:ss or H:mm:ss
    RegExp(r'^(\d{1,2}):(\d{2}):(\d{2})$'),
  ];
  
  for (var pattern in patterns) {
    var match = pattern.firstMatch(timeStr.trim());
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      
      // Validate time ranges
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }
      
      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    }
  }
  
  // Try parsing as full datetime string
  try {
    return DateTime.parse(timeStr);
  } catch (e) {
    // Failed to parse
    return null;
  }
}
