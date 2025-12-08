import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border, TextSpan;import 'dart:io';
import 'package:intl/intl.dart';


class ExportExcelScreen extends StatefulWidget {
  const ExportExcelScreen({super.key});

  @override
  State<ExportExcelScreen> createState() => _ExportExcelScreenState();
}

class _ExportExcelScreenState extends State<ExportExcelScreen> {
  bool _isDragging = false;
  List<ExcelData> _uploadedFiles = [];
  bool _isProcessing = false;

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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight. bold,
                  color: const Color(0xFF1F2937),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'To "add multiple user records" download, fill and upload the "user template" file.',
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
                  DropTarget(
                    onDragDone: (detail) async {
                      setState(() {
                        _isDragging = false;
                      });
                      
                      for (var file in detail. files) {
                        if (file. path.endsWith('.xlsx') || file.path.endsWith('. xls')) {
                          await _processExcelFile(file. path);
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
                        color: Colors. white,
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
                              Text(
                                '${_uploadedFiles.length} file(s)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
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
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
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
                fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
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
              'Processed on',
              style: TextStyle(
                fontWeight: FontWeight.w600,
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
        rows: _uploadedFiles.map((data) {
          return DataRow(
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
                        color: Colors. grey[800],
                      ),
                    ),
                  ],
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
                  style: TextStyle(color: Colors. grey[800]),
                ),
              ),
              DataCell(
                Text(
                  data. kekayaan,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              DataCell(
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(data. processedOn),
                  style: TextStyle(color: Colors. grey[600], fontSize: 13),
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
        }). toList(),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform. pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );

    if (result != null && result. files.single.path != null) {
      await _processExcelFile(result.files.single. path!);
    }
  }

  Future<void> _processExcelFile(String filePath) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel. decodeBytes(bytes);

      // Ambil sheet pertama
      var sheet = excel.tables[excel.tables.keys.first];
      
      if (sheet != null) {
        // Skip header (row 0) dan mulai dari row 1
        for (var row in sheet.rows.skip(1)) {
          if (row.length >= 5) {
            // Kolom B=1, C=2, D=3, E=4 (index dimulai dari 0)
            var nama = row[1]?.value?.toString() ?? '';
            var kampus = row[2]?.value?.toString() ?? '';
            var alamat = row[3]?.value?.toString() ??  '';
            var kekayaan = row[4]?.value?. toString() ?? '';

            // Skip jika semua data kosong
            if (nama.isEmpty && kampus.isEmpty && alamat.isEmpty && kekayaan.isEmpty) {
              continue;
            }

            setState(() {
              _uploadedFiles.add(ExcelData(
                fileName: filePath.split('/').last.split('\\').last,
                nama: nama,
                kampus: kampus,
                alamat: alamat,
                kekayaan: kekayaan,
                processedOn: DateTime.now(),
              ));
            });
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context). showSnackBar(
          SnackBar(
            content: const Text('File berhasil diproses! '),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
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
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

class ExcelData {
  final String fileName;
  final String nama;
  final String kampus;
  final String alamat;
  final String kekayaan;
  final DateTime processedOn;

  ExcelData({
    required this.fileName,
    required this.nama,
    required this. kampus,
    required this. alamat,
    required this. kekayaan,
    required this.processedOn,
  });
}