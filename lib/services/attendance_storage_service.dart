import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_summary.dart';
import '../models/attendance_record.dart';
import '../models/employee.dart';
import '../models/department.dart';

class AttendanceStorageService {
  static const String _storageKey = 'attendance_history';

  /// Save attendance data for a specific year and month
  static Future<bool> saveAttendanceData({
    required int year,
    required int month,
    required List<AttendanceSummary> summaries,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing data
      final String? existingData = prefs.getString(_storageKey);
      Map<String, dynamic> allData = {};
      
      if (existingData != null) {
        allData = json.decode(existingData);
      }
      
      // Create key for this month/year
      final key = '$year-${month.toString().padLeft(2, '0')}';
      
      // Convert summaries to JSON
      final summariesJson = summaries.map((summary) => _summaryToJson(summary)).toList();
      
      // Store the data
      allData[key] = summariesJson;
      
      // Save back to preferences
      await prefs.setString(_storageKey, json.encode(allData));
      
      return true;
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
      final prefs = await SharedPreferences.getInstance();
      final String? existingData = prefs.getString(_storageKey);
      
      if (existingData == null) {
        return null;
      }
      
      final Map<String, dynamic> allData = json.decode(existingData);
      final key = '$year-${month.toString().padLeft(2, '0')}';
      
      if (!allData.containsKey(key)) {
        return null;
      }
      
      final List<dynamic> summariesJson = allData[key];
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
      final prefs = await SharedPreferences.getInstance();
      final String? existingData = prefs.getString(_storageKey);
      
      if (existingData == null) {
        return [];
      }
      
      final Map<String, dynamic> allData = json.decode(existingData);
      final List<Map<String, int>> months = [];
      
      for (var key in allData.keys) {
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
