import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/attendance_summary.dart';
import '../models/attendance_record.dart';
import '../models/employee.dart';
import '../models/department.dart';
import 'database_service.dart';

class AttendanceStorageService {

  /// Save attendance data for a specific year and month
  static Future<bool> saveAttendanceData({
    required int year,
    required int month,
    required List<AttendanceSummary> summaries,
    List<int>? excelFileBytes,
    String? excelFilename,
  }) async {
    try {
      // Create key for this month/year
      final key = '$year-${month.toString().padLeft(2, '0')}';
      
      // Convert summaries to JSON
      final summariesJson = summaries.map((summary) => _summaryToJson(summary)).toList();
      
      // Store the data
      final jsonData = json.encode(summariesJson);
      
      // Save to database
      return await DatabaseService.saveData(
        key, 
        jsonData, 
        excelFileBytes: excelFileBytes,
        excelFilename: excelFilename,
      );
    } catch (e) {
      debugPrint('Error saving attendance data: $e');
      return false;
    }
  }

  /// Load attendance data for a specific year and month
  static Future<List<AttendanceSummary>?> loadAttendanceData({
    required int year,
    required int month,
  }) async {
    try {
      final key = '$year-${month.toString().padLeft(2, '0')}';
      
      final jsonData = await DatabaseService.loadData(key);
      
      if (jsonData == null) {
        return null;
      }
      
      final List<dynamic> summariesJson = json.decode(jsonData);
      final summaries = summariesJson.map((json) => _summaryFromJson(json)).toList();
      
      return summaries;
    } catch (e) {
      debugPrint('Error loading attendance data: $e');
      return null;
    }
  }

  /// Get all available months with data
  static Future<List<Map<String, int>>> getAvailableMonths() async {
    try {
      final keys = await DatabaseService.getAllKeys();
      final List<Map<String, int>> months = [];
      
      for (var key in keys) {
        final parts = key.split('-');
        if (parts.length == 2) {
          months.add({
            'year': int.parse(parts[0]),
            'month': int.parse(parts[1]),
          });
        }
      }
      
      // Sort by year and month descending
      months.sort((a, b) {
        final yearCompare = b['year']!.compareTo(a['year']!);
        if (yearCompare != 0) return yearCompare;
        return b['month']!.compareTo(a['month']!);
      });
      
      return months;
    } catch (e) {
      debugPrint('Error getting available months: $e');
      return [];
    }
  }

  /// Delete attendance data for a specific year and month
  static Future<bool> deleteAttendanceData({
    required int year,
    required int month,
  }) async {
    try {
      final key = '$year-${month.toString().padLeft(2, '0')}';
      
      // Delete from database
      return await DatabaseService.deleteData(key);
    } catch (e) {
      debugPrint('Error deleting attendance data: $e');
      return false;
    }
  }

  /// Get Excel file for a specific year and month
  static Future<Map<String, dynamic>?> getExcelFile({
    required int year,
    required int month,
  }) async {
    try {
      final key = '$year-${month.toString().padLeft(2, '0')}';
      return await DatabaseService.getExcelFile(key);
    } catch (e) {
      debugPrint('Error getting Excel file: $e');
      return null;
    }
  }

  // Convert AttendanceSummary to JSON
  static Map<String, dynamic> _summaryToJson(AttendanceSummary summary) {
    return {
      'employee': {
        'userId': summary.employee.userId,
        'name': summary.employee.name,
        'department': summary.employee.department.name,
      },
      'totalMasukMinutes': summary.totalMasukMinutes,
      'totalTelatMinutes': summary.totalTelatMinutes,
      'totalLemburMinutes': summary.totalLemburMinutes,
      'daysMasuk': summary.daysMasuk,
      'daysTelat': summary.daysTelat,
      'daysLembur': summary.daysLembur,
      'records': summary.records.map((record) => _recordToJson(record)).toList(),
    };
  }

  // Convert JSON to AttendanceSummary
  static AttendanceSummary _summaryFromJson(Map<String, dynamic> json) {
    final employeeJson = json['employee'];
    final employee = Employee(
      userId: employeeJson['userId'],
      name: employeeJson['name'],
      department: Department.fromString(employeeJson['department']),
    );
    
    final records = (json['records'] as List)
        .map((recordJson) => _recordFromJson(recordJson))
        .toList();
    
    return AttendanceSummary(
      employee: employee,
      totalMasukMinutes: json['totalMasukMinutes'],
      totalTelatMinutes: json['totalTelatMinutes'],
      totalLemburMinutes: json['totalLemburMinutes'],
      daysMasuk: json['daysMasuk'],
      daysTelat: json['daysTelat'],
      daysLembur: json['daysLembur'],
      records: records,
    );
  }

  // Convert AttendanceRecord to JSON
  static Map<String, dynamic> _recordToJson(AttendanceRecord record) {
    return {
      'date': record.date.toIso8601String(),
      'dayOfWeek': record.dayOfWeek,
      'jamMasukPagi': record.jamMasukPagi,
      'jamKeluarPagi': record.jamKeluarPagi,
      'jamMasukSiang': record.jamMasukSiang,
      'jamKeluarSiang': record.jamKeluarSiang,
      'jamMasukLembur': record.jamMasukLembur,
      'jamKeluarLembur': record.jamKeluarLembur,
      'notes': record.notes,
    };
  }

  // Convert JSON to AttendanceRecord
  static AttendanceRecord _recordFromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      dayOfWeek: json['dayOfWeek'],
      jamMasukPagi: json['jamMasukPagi'],
      jamKeluarPagi: json['jamKeluarPagi'],
      jamMasukSiang: json['jamMasukSiang'],
      jamKeluarSiang: json['jamKeluarSiang'],
      jamMasukLembur: json['jamMasukLembur'],
      jamKeluarLembur: json['jamKeluarLembur'],
      notes: json['notes'],
    );
  }
}
