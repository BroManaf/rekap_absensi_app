import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border, TextSpan;
import 'dart:io';
import 'package:intl/intl.dart';
import '../utils/attendance_calculator.dart';

class ExportExcelScreen extends StatefulWidget {
  const ExportExcelScreen({super.key});

  @override
  State<ExportExcelScreen> createState() => _ExportExcelScreenState();
}

class _ExportExcelScreenState extends State<ExportExcelScreen> {
  bool _isDragging = false;
  List<ExcelData> _uploadedFiles = [];
  bool _isProcessing = false;
  int _totalRowsProcessed = 0;
  int _totalSheetsProcessed = 0;

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
            'Upload Excel',
            style: Theme.of(context).textTheme.headlineMedium?. copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'To "add multiple user records" download, fill and upload the "user template" file.',
            style: TextStyle(
              color: Colors. grey[600],
              fontSize: 14,
            ),
          ),
          
          // Statistics
          if (_uploadedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.table_chart_outlined,
                    label: 'Total Sheets',
                    value: '$_totalSheetsProcessed',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.dataset_outlined,
                    label: 'Total Rows',
                    value: '$_totalRowsProcessed',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    icon: Icons.description_outlined,
                    label: 'Total Records',
                    value: '${_uploadedFiles.length}',
                    color: Colors. purple,
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 32),
          
          // Upload Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Drag & Drop Area
                  DropTarget(
                    onDragDone: (detail) async {
                      setState(() {
                        _isDragging = false;
                      });
                      
                      for (var file in detail.files) {
                        if (file. path.endsWith('.xlsx') || file.path.endsWith('.xls')) {
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
                            Icons.folder_open_rounded,
                            size: 64,
                            color: _isDragging 
                                ?  const Color(0xFF6366F1)
                                : const Color(0xFFFFB84D),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors. grey[700],
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
                                const TextSpan(text: ' to '),
                                const TextSpan(
                                  text: 'upload',
                                  style: TextStyle(
                                    color: Color(0xFF6366F1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload . xls, .xlsx, .csv and .xml format files here',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'All sheets in the file will be processed automatically',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Uploaded Files Section
                  if (_uploadedFiles.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Container(
                      width: double. infinity,
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
                              Text(
                                'Uploaded Files',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${_uploadedFiles.length} record(s)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton. icon(
                                    onPressed: () {
                                      setState(() {
                                        _uploadedFiles.clear();
                                        _totalRowsProcessed = 0;
                                        _totalSheetsProcessed = 0;
                                      });
                                    },
                                    icon: const Icon(Icons.clear_all, size: 16),
                                    label: const Text('Clear All'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[50],
                                      foregroundColor: Colors.red[700],
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
                          _buildDataTable(),
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
                            'Processing all sheets...',
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color. withOpacity(0.1),
          borderRadius: BorderRadius. circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color. withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          const Color(0xFFF9FAFB),
        ),
        columns: [
          DataColumn(
            label: Text(
              'File Name',
              style: TextStyle(
                fontWeight: FontWeight. w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Sheet Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Row #',
              style: TextStyle(
                fontWeight: FontWeight. w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Nama',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors. grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Kampus',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Alamat',
              style: TextStyle(
                fontWeight: FontWeight. w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Kekayaan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Lama Telat',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Lama Masuk',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Lama Lembur',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Kerja',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Processed on',
              style: TextStyle(
                fontWeight: FontWeight. w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Actions',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
        rows: _uploadedFiles.asMap().entries.map((entry) {
          int index = entry.key;
          ExcelData data = entry.value;
          
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (index. isEven) {
                  return Colors.grey[50];
                }
                return null;
              },
            ),
            cells: [
              DataCell(
                Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      size: 18,
                      color: Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.fileName,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
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
                    data.sheetName,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  '#${data.rowNumber}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  data.nama,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.kampus,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.alamat,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.kekayaan,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.lamaTelat,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.lamaMasuk,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.lamaLembur,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data.totalKerja,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(data.processedOn),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.download_outlined,
                        size: 20,
                        color: Color(0xFF6366F1),
                      ),
                      onPressed: () {
                        // TODO: Implement download
                      },
                      tooltip: 'Download',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _uploadedFiles.remove(data);
                        });
                      },
                      tooltip: 'Delete',
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
    FilePickerResult?  result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      await _processExcelFile(result. files.single.path!);
    }
  }

  Future<void> _processExcelFile(String filePath) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      int sheetsProcessed = 0;
      int rowsProcessed = 0;
      int recordsAdded = 0;

      // Loop through ALL sheets
      for (var tableName in excel.tables.keys) {
        var sheet = excel. tables[tableName];
        
        if (sheet != null && sheet.rows. isNotEmpty) {
          sheetsProcessed++;
          
          // Parse header row (row 0) to find column indices
          var headerRow = sheet.rows[0];
          int? masukPagiIdx;
          int? keluarSiangIdx;
          int? masukLemburIdx;
          
          // Find time columns using case-insensitive keyword matching
          for (int i = 0; i < headerRow.length; i++) {
            String header = headerRow[i]?.value?.toString().toLowerCase() ?? '';
            
            // Check for "masuk lembur" or "jam lembur" first (more specific)
            if ((header.contains('masuk') && header.contains('lembur')) || 
                (header.contains('jam') && header.contains('lembur'))) {
              masukLemburIdx = i;
            }
            // Check for "masuk pagi" or "jam masuk"
            else if ((header.contains('masuk') && header.contains('pagi')) || 
                     (header == 'jam masuk' || header == 'masuk')) {
              masukPagiIdx = i;
            }
            // Check for "keluar siang" or "jam keluar"
            else if ((header.contains('keluar') && header.contains('siang')) || 
                     (header == 'jam keluar' || header == 'keluar')) {
              keluarSiangIdx = i;
            }
          }
          
          // Skip header (row 0) and start from row 1
          for (var i = 1; i < sheet. rows.length; i++) {
            var row = sheet.rows[i];
            rowsProcessed++;
            
            // Check if row has minimum required columns (A-E, indices 0-4)
            if (row.length >= 5) {
              // Columns B=1, C=2, D=3, E=4 (index starts from 0)
              var nama = row[1]?.value?.toString() ?? '';
              var kampus = row[2]?.value?.toString() ?? '';
              var alamat = row[3]?.value?.toString() ??  '';
              var kekayaan = row[4]?.value?. toString() ?? '';

              // Skip if all data is empty
              if (nama.isEmpty && kampus.isEmpty && alamat. isEmpty && kekayaan.isEmpty) {
                continue;
              }

              // Parse time values if time columns exist
              String lamaTelat = '-';
              String lamaMasuk = '-';
              String lamaLembur = '-';
              String totalKerja = '-';
              
              if (masukPagiIdx != null && masukPagiIdx < row.length) {
                DateTime? masukPagiTime = _parseTimeValue(row[masukPagiIdx]?.value);
                
                if (masukPagiTime != null) {
                  DateTime? keluarSiangTime;
                  DateTime? masukLemburTime;
                  
                  if (keluarSiangIdx != null && keluarSiangIdx < row.length) {
                    keluarSiangTime = _parseTimeValue(row[keluarSiangIdx]?.value);
                  }
                  
                  if (masukLemburIdx != null && masukLemburIdx < row.length) {
                    masukLemburTime = _parseTimeValue(row[masukLemburIdx]?.value);
                  }
                  
                  // Compute attendance
                  try {
                    var result = computeAttendance(
                      masukPagi: masukPagiTime,
                      keluarSiang: keluarSiangTime,
                      masukLembur: masukLemburTime,
                    );
                    
                    lamaTelat = result.lamaTelatFormatted;
                    lamaMasuk = result.lamaMasukFormatted;
                    lamaLembur = result.lamaLemburFormatted;
                    totalKerja = result.totalFormatted;
                  } catch (e) {
                    // If calculation fails, keep default '-' values
                    // Log error for debugging (in debug mode)
                    assert(() {
                      print('Attendance calculation error for row ${i + 1}: $e');
                      return true;
                    }());
                  }
                }
              }

              setState(() {
                _uploadedFiles.add(ExcelData(
                  fileName: filePath. split('/').last. split('\\').last,
                  sheetName: tableName,
                  rowNumber: i + 1, // +1 because index starts from 0
                  nama: nama,
                  kampus: kampus,
                  alamat: alamat,
                  kekayaan: kekayaan,
                  processedOn: DateTime.now(),
                  lamaTelat: lamaTelat,
                  lamaMasuk: lamaMasuk,
                  lamaLembur: lamaLembur,
                  totalKerja: totalKerja,
                ));
                recordsAdded++;
              });
            }
          }
        }
      }

      setState(() {
        _totalSheetsProcessed += sheetsProcessed;
        _totalRowsProcessed += rowsProcessed;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File berhasil diproses! $sheetsProcessed sheet(s), $recordsAdded record(s) ditambahkan.',
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context). showSnackBar(
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
  
  /// Parse time value from Excel cell
  /// Handles both DateTime objects and string values
  DateTime? _parseTimeValue(dynamic value) {
    if (value == null) return null;
    
    // If already DateTime, use it
    if (value is DateTime) {
      return value;
    }
    
    // If string, try to parse it
    if (value is String) {
      return parseTimeString(value, DateTime.now());
    }
    
    // Try converting to string and parse
    try {
      String strValue = value.toString();
      return parseTimeString(strValue, DateTime.now());
    } catch (e) {
      return null;
    }
  }
}

class ExcelData {
  final String fileName;
  final String sheetName;
  final int rowNumber;
  final String nama;
  final String kampus;
  final String alamat;
  final String kekayaan;
  final DateTime processedOn;
  final String lamaTelat;
  final String lamaMasuk;
  final String lamaLembur;
  final String totalKerja;

  ExcelData({
    required this.fileName,
    required this.sheetName,
    required this.rowNumber,
    required this.nama,
    required this.kampus,
    required this.alamat,
    required this.kekayaan,
    required this.processedOn,
    this.lamaTelat = '-',
    this.lamaMasuk = '-',
    this.lamaLembur = '-',
    this.totalKerja = '-',
  });
}