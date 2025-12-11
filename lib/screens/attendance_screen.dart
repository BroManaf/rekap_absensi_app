import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border, TextSpan;
import 'dart:io';
import '../models/department.dart';
import '../models/employee.dart';
import '../models/attendance_record.dart';
import '../models/attendance_summary.dart';
import '../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isDragging = false;
  List<AttendanceSummary> _summaries = [];
  bool _isProcessing = false;
  String? _currentFileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Rekap Absensi Karyawan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload file Excel absensi untuk melihat rekap kehadiran dan keterlambatan',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 32),

          // Upload Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Drag & Drop Area
                  if (_summaries.isEmpty)
                    DropTarget(
                      onDragDone: (detail) async {
                        setState(() {
                          _isDragging = false;
                        });

                        for (var file in detail.files) {
                          if (file.path.endsWith('.xlsx') ||
                              file.path.endsWith('.xls')) {
                            await _processExcelFile(file.path);
                          }
                        }
                      },
                      onDragEntered: (detail) {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onDragExited: (detail) {
                        setState(() {
                          _isDragging = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isDragging
                                ? const Color(0xFF6366F1)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.upload_file_rounded,
                              size: 64,
                              color: _isDragging
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFFFB84D),
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                children: [
                                  const TextSpan(text: 'Drop your files here or '),
                                  WidgetSpan(
                                    child: InkWell(
                                      onTap: _pickFile,
                                      child: const Text(
                                        'click here',
                                        style: TextStyle(
                                          color: Color(0xFF6366F1),
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(text: ' to upload'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Excel file (.xlsx, .xls)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Summary Table
                  if (_summaries.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rekap Absensi',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  if (_currentFileName != null)
                                    Text(
                                      'File: $_currentFileName',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${_summaries.length} karyawan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _summaries.clear();
                                        _currentFileName = null;
                                      });
                                    },
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text('Upload Baru'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSummaryTable(),
                        ],
                      ),
                    ),
                  ],

                  if (_isProcessing)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Memproses file Excel...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          const Color(0xFFF9FAFB),
        ),
        columns: [
          DataColumn(
            label: Text(
              'No',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Nama Karyawan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'User ID',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Department',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Masuk',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Telat',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Lembur',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
        rows: _summaries.asMap().entries.map((entry) {
          int index = entry.key;
          AttendanceSummary summary = entry.value;

          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (index.isEven) {
                  return Colors.grey[50];
                }
                return null;
              },
            ),
            cells: [
              DataCell(
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  summary.employee.name,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    summary.employee.userId,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    summary.employee.department.name,
                    style: TextStyle(
                      color: Colors.purple[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      summary.totalMasukFormatted,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      summary.totalTelatFormatted,
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Icon(
                      Icons.nights_stay,
                      size: 16,
                      color: Colors.indigo[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      summary.totalLemburFormatted,
                      style: TextStyle(
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      await _processExcelFile(result.files.single.path!);
    }
  }

  Future<void> _processExcelFile(String filePath) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<AttendanceSummary> summaries = [];

      // Define column mappings for each employee position in a sheet
      // Each sheet can have up to 3 employees
      final employeeColumnMappings = [
        // Employee 1
        {
          'deptCols': [2, 3, 4, 5, 6], // C-G
          'nameCols': [8, 9, 10], // I-K
          'userIdCols': [8, 9, 10], // I-K (row 3)
          'jamMasukPagi': [2, 3], // C, D
          'jamKeluarPagi': 4, // E
          'jamMasukSiang': [5, 6], // F, G
          'jamKeluarSiang': 7, // H
          'jamMasukLembur': [8, 9], // I, J
          'jamKeluarLembur': 10, // K
        },
        // Employee 2
        {
          'deptCols': [13, 14, 15, 16, 17], // N-R
          'nameCols': [19, 20, 21], // T-V
          'userIdCols': [19, 20, 21], // T-V (row 3)
          'jamMasukPagi': [13, 14], // N, O
          'jamKeluarPagi': 15, // P
          'jamMasukSiang': [16, 17], // Q, R
          'jamKeluarSiang': 18, // S
          'jamMasukLembur': [19, 20], // T, U
          'jamKeluarLembur': 21, // V
        },
        // Employee 3
        {
          'deptCols': [24, 25, 26, 27, 28], // Y-AC
          'nameCols': [30, 31, 32], // AE-AG
          'userIdCols': [30, 31, 32], // AE-AG (row 3)
          'jamMasukPagi': [24, 25], // Y, Z
          'jamKeluarPagi': 26, // AA
          'jamMasukSiang': [27, 28], // AB, AC
          'jamKeluarSiang': 29, // AD
          'jamMasukLembur': [30, 31], // AE, AF
          'jamKeluarLembur': 32, // AG
        },
      ];

      // Process each sheet
      for (var tableName in excel.tables.keys) {
        var sheet = excel.tables[tableName];

        if (sheet != null && sheet.rows.isNotEmpty) {
          // Process each employee position in the sheet
          for (var empMapping in employeeColumnMappings) {
            final employeeSummary = _processEmployee(sheet, empMapping);
            if (employeeSummary != null) {
              summaries.add(employeeSummary);
            }
          }
        }
      }

      setState(() {
        _summaries = summaries;
        _currentFileName = filePath.split('/').last.split('\\').last;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File berhasil diproses! ${summaries.length} karyawan ditemukan.',
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  /// Process a single employee from the sheet using the provided column mappings
  AttendanceSummary? _processEmployee(Sheet sheet, Map<String, dynamic> mapping) {
    // Read department from row 2 (index 1)
    String departmentStr = '';
    for (int col in mapping['deptCols']) {
      if (sheet.rows.length > 1 && sheet.rows[1].length > col) {
        var cell = sheet.rows[1][col];
        if (cell != null && cell.value != null) {
          departmentStr = cell.value.toString();
          break;
        }
      }
    }

    // Read employee name from row 2 (index 1)
    String employeeName = '';
    for (int col in mapping['nameCols']) {
      if (sheet.rows.length > 1 && sheet.rows[1].length > col) {
        var cell = sheet.rows[1][col];
        if (cell != null && cell.value != null) {
          employeeName = cell.value.toString();
          break;
        }
      }
    }

    // Read UserID from row 3 (index 2)
    String userId = '';
    for (int col in mapping['userIdCols']) {
      if (sheet.rows.length > 2 && sheet.rows[2].length > col) {
        var cell = sheet.rows[2][col];
        if (cell != null && cell.value != null) {
          userId = cell.value.toString();
          break;
        }
      }
    }

    // Skip if essential data is missing
    if (employeeName.isEmpty || userId.isEmpty) {
      if (kDebugMode) {
        print('[DEBUG] Skipping employee: employeeName=$employeeName, userId=$userId');
      }
      return null;
    }

    if (kDebugMode) {
      print('[DEBUG] Processing employee: $employeeName (ID: $userId), department: $departmentStr');
    }

    // Create employee object
    final department = Department.fromString(departmentStr);
    if (kDebugMode) {
      print('[DEBUG] Department parsed: ${department.name}, jamMasuk: ${department.jamMasuk}');
    }
    final employee = Employee(
      userId: userId,
      name: employeeName,
      department: department,
    );

    // Read attendance data from rows 12-42 (index 11-41) for dates 1-31
    List<AttendanceRecord> records = [];
    if (kDebugMode) {
      print('[DEBUG] Reading attendance data for ${employee.name}');
    }
    for (int i = 11; i < 42 && i < sheet.rows.length; i++) {
      var row = sheet.rows[i];
      
      // Read day of week from column B (index 1)
      // Format: "dd Sen", "dd Sel", "dd Rab", "dd Kam", "dd Jum", "dd Sab", "dd Min"
      String? dayOfWeek;
      if (row.length > 1 && row[1] != null && row[1]!.value != null) {
        final cellValue = row[1]!.value.toString().trim();
        // Extract day abbreviation (last 3 characters after space)
        // Examples: "1 Sen" -> "Sen", "15 Min" -> "Min"
        final parts = cellValue.split(' ');
        if (parts.length >= 2) {
          dayOfWeek = parts.last; // Sen, Sel, Rab, Kam, Jum, Sab, Min
        }
      }
      
      // Get date from columns C-G (always use employee 1's date columns)
      // Note: Date is used only for record identification, not for calculations
      // All calculations are based on time of day only
      // We use a fixed reference date to avoid issues with month boundaries
      const referenceYear = 2024;
      const referenceMonth = 1; // January has 31 days
      DateTime? date;
      for (int col = 2; col <= 6; col++) {
        if (row.length > col) {
          var cell = row[col];
          if (cell != null && cell.value != null) {
            try {
              // Try to parse as date or number (day of month)
              final value = cell.value.toString();
              final dayOfMonth = int.tryParse(value);
              if (dayOfMonth != null && dayOfMonth >= 1 && dayOfMonth <= 31) {
                date = DateTime(referenceYear, referenceMonth, dayOfMonth);
              }
            } catch (e) {
              // Ignore parsing errors
            }
            break;
          }
        }
      }

      if (date == null) {
        // Use row index as day (row 12 = day 1, row 13 = day 2, etc.)
        final dayNumber = i - 10;
        if (dayNumber >= 1 && dayNumber <= 31) {
          date = DateTime(referenceYear, referenceMonth, dayNumber);
        } else {
          // Fallback for invalid row numbers
          date = DateTime(referenceYear, referenceMonth, 1);
        }
      }

      if (kDebugMode && dayOfWeek != null) {
        print('[DEBUG] Row ${i+1} (Day ${date.day}): dayOfWeek=$dayOfWeek');
      }

      // Extract time data using the mapping
      String? jamMasukPagi1 = _getCellValue(row, mapping['jamMasukPagi'][0]);
      String? jamMasukPagi2 = _getCellValue(row, mapping['jamMasukPagi'][1]);
      String? jamKeluarPagi = _getCellValue(row, mapping['jamKeluarPagi']);
      String? jamMasukSiang1 = _getCellValue(row, mapping['jamMasukSiang'][0]);
      String? jamMasukSiang2 = _getCellValue(row, mapping['jamMasukSiang'][1]);
      String? jamKeluarSiang = _getCellValue(row, mapping['jamKeluarSiang']);
      String? jamMasukLembur1 = _getCellValue(row, mapping['jamMasukLembur'][0]);
      String? jamMasukLembur2 = _getCellValue(row, mapping['jamMasukLembur'][1]);
      String? jamKeluarLembur = _getCellValue(row, mapping['jamKeluarLembur']);

      // Use first non-null value for masuk pagi
      String? jamMasukPagi = jamMasukPagi1 ?? jamMasukPagi2;
      String? jamMasukSiang = jamMasukSiang1 ?? jamMasukSiang2;
      String? jamMasukLembur = jamMasukLembur1 ?? jamMasukLembur2;

      records.add(AttendanceRecord(
        date: date,
        dayOfWeek: dayOfWeek,
        jamMasukPagi: jamMasukPagi,
        jamKeluarPagi: jamKeluarPagi,
        jamMasukSiang: jamMasukSiang,
        jamKeluarSiang: jamKeluarSiang,
        jamMasukLembur: jamMasukLembur,
        jamKeluarLembur: jamKeluarLembur,
      ));
    }

    // Calculate summary
    final summary = AttendanceService.calculateSummary(employee, records);
    return summary;
  }

  /// Extract cell value and convert Excel time formats to HH:MM strings
  /// 
  /// Excel stores times as decimal values (0.0 to 1.0), e.g., 0.40625 = 09:45
  /// This method detects and converts such values to "HH:MM" format.
  /// 
  /// Note: Using dynamic casting because Excel package cell value types
  /// are not directly accessible/importable.
  /// 
  /// TODO: Remove debug logging after validating the fix with actual Excel data
  String? _getCellValue(List<Data?> row, int col) {
    if (row.length > col && row[col] != null && row[col]!.value != null) {
      final cell = row[col]!;
      final cellValue = cell.value;
      
      // Try to extract the actual value from the CellValue wrapper
      dynamic rawValue;
      
      try {
        // CellValue types have a 'value' property with the actual data
        rawValue = (cellValue as dynamic).value;
      } catch (e) {
        // Fallback if we can't access the value property
        // This shouldn't happen with the Excel package but included for safety
        rawValue = cellValue;
      }
      
      // If rawValue is a number between 0 and 1, it might be an Excel time
      // Note: Excel times are in range [0, 1) where:
      //   0.0 = 00:00 (midnight), 0.5 = 12:00 (noon), 0.99999 = 23:59:59
      //   1.0 would represent next day midnight and is not a valid same-day time
      if (rawValue is num && rawValue >= 0 && rawValue < 1) {
        // Excel stores times as decimal values (0.0 to 1.0)
        // E.g., 0.40625 = 09:45 (9.75 hours / 24 hours)
        final totalMinutes = (rawValue * 24 * 60).round();
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        final timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
        if (kDebugMode) {
          print('[DEBUG] _getCellValue col=$col: Converted Excel time $rawValue to $timeString');
        }
        return timeString;
      }
      
      // For other values (strings, integers, etc.), convert to string
      if (rawValue != null) {
        final stringValue = rawValue.toString().trim();
        if (stringValue.isNotEmpty) {
          if (kDebugMode) {
            print('[DEBUG] _getCellValue col=$col: "$stringValue" (type: ${rawValue.runtimeType})');
          }
          return stringValue;
        }
      }
    }
    return null;
  }
}
