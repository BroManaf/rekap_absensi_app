import 'package:flutter/material.dart';
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

      // Process each sheet (assuming each sheet is one employee)
      for (var tableName in excel.tables.keys) {
        var sheet = excel.tables[tableName];

        if (sheet != null && sheet.rows.isNotEmpty) {
          // Read department from row 2 (index 1), columns C-G (index 2-6)
          String departmentStr = '';
          for (int col = 2; col <= 6; col++) {
            if (sheet.rows.length > 1 && sheet.rows[1].length > col) {
              var cell = sheet.rows[1][col];
              if (cell != null && cell.value != null) {
                departmentStr = cell.value.toString();
                break;
              }
            }
          }

          // Read employee name from row 2 (index 1), columns I-K (index 8-10)
          String employeeName = '';
          for (int col = 8; col <= 10; col++) {
            if (sheet.rows.length > 1 && sheet.rows[1].length > col) {
              var cell = sheet.rows[1][col];
              if (cell != null && cell.value != null) {
                employeeName = cell.value.toString();
                break;
              }
            }
          }

          // Read UserID from row 3 (index 2), columns I-K (index 8-10)
          String userId = '';
          for (int col = 8; col <= 10; col++) {
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
            continue;
          }

          // Create employee object
          final department = Department.fromString(departmentStr);
          final employee = Employee(
            userId: userId,
            name: employeeName,
            department: department,
          );

          // Read attendance data from rows 12-42 (index 11-41) for dates 1-31
          List<AttendanceRecord> records = [];
          for (int i = 11; i < 42 && i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            
            // Get date from columns C-G
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
                      date = DateTime(2024, 1, dayOfMonth); // Use a dummy year/month
                    }
                  } catch (e) {
                    // Ignore parsing errors
                  }
                  break;
                }
              }
            }

            if (date == null) {
              // Use row index as day
              date = DateTime(2024, 1, i - 10);
            }

            // Column mappings (0-indexed):
            // C=2, D=3, E=4, F=5, G=6, H=7, I=8, J=9, K=10
            String? jamMasukPagi1 = _getCellValue(row, 2);
            String? jamMasukPagi2 = _getCellValue(row, 3);
            String? jamKeluarPagi = _getCellValue(row, 4);
            String? jamMasukSiang1 = _getCellValue(row, 5);
            String? jamMasukSiang2 = _getCellValue(row, 6);
            String? jamKeluarSiang = _getCellValue(row, 7);
            String? jamMasukLembur1 = _getCellValue(row, 8);
            String? jamMasukLembur2 = _getCellValue(row, 9);
            String? jamKeluarLembur = _getCellValue(row, 10);

            // Use first non-null value for masuk pagi
            String? jamMasukPagi = jamMasukPagi1 ?? jamMasukPagi2;
            String? jamMasukSiang = jamMasukSiang1 ?? jamMasukSiang2;
            String? jamMasukLembur = jamMasukLembur1 ?? jamMasukLembur2;

            records.add(AttendanceRecord(
              date: date,
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
          summaries.add(summary);
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

  String? _getCellValue(List<Data?> row, int col) {
    if (row.length > col && row[col] != null && row[col]!.value != null) {
      final value = row[col]!.value.toString().trim();
      return value.isEmpty ? null : value;
    }
    return null;
  }
}
