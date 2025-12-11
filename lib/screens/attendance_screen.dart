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
import '../theme/app_theme.dart';

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
      decoration: AppTheme.gradientBackground,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppTheme.primaryTextColor,
                    AppTheme.primaryAccent,
                  ],
                ).createShader(bounds),
                child: Text(
                  'Rekap Absensi Karyawan',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload file Excel absensi untuk melihat rekap kehadiran dan keterlambatan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
              ),
            ],
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.all(64),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isDragging
                                ? AppTheme.primaryAccent
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                          boxShadow: _isDragging
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryAccent.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : AppTheme.subtleCardShadow,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isDragging
                                      ? [
                                          AppTheme.accentGradientStart,
                                          AppTheme.accentGradientEnd,
                                        ]
                                      : [
                                          AppTheme.surfaceColor,
                                          AppTheme.cardColor,
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.cloud_upload_rounded,
                                size: 40,
                                color: _isDragging
                                    ? AppTheme.primaryTextColor
                                    : AppTheme.primaryAccent,
                              ),
                            ),
                            const SizedBox(height: 24),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.primaryTextColor,
                                    ),
                                children: [
                                  const TextSpan(text: 'Drop your files here or '),
                                  WidgetSpan(
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: _pickFile,
                                        child: Text(
                                          'browse',
                                          style: TextStyle(
                                            color: AppTheme.primaryAccent,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Supported formats: .xlsx, .xls',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.tertiaryTextColor,
                                    ),
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
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.cardShadow,
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
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppTheme.primaryTextColor,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (_currentFileName != null)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.insert_drive_file_rounded,
                                          size: 14,
                                          color: AppTheme.tertiaryTextColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _currentFileName!,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.tertiaryTextColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people_rounded,
                                          size: 16,
                                          color: AppTheme.primaryAccent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${_summaries.length} karyawan',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.secondaryTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _summaries.clear();
                                        _currentFileName = null;
                                      });
                                    },
                                    icon: const Icon(Icons.refresh_rounded, size: 18),
                                    label: const Text('Upload Baru'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryAccent,
                                      foregroundColor: AppTheme.primaryTextColor,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _buildSummaryTable(),
                        ],
                      ),
                    ),
                  ],

                  if (_isProcessing)
                    Container(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Memproses file Excel...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.secondaryTextColor,
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _summaries.length,
      itemBuilder: (context, index) {
        final summary = _summaries[index];
        return _buildEmployeeCard(summary, index);
      },
    );
  }

  Widget _buildEmployeeCard(AttendanceSummary summary, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: AppTheme.subtleCardShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          childrenPadding: const EdgeInsets.all(20),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentGradientStart,
                  AppTheme.accentGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryAccent.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.infoColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.infoColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            summary.employee.userId,
                            style: const TextStyle(
                              color: AppTheme.infoColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.secondaryAccent.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            summary.employee.department.name,
                            style: const TextStyle(
                              color: AppTheme.secondaryAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      Icons.login_rounded,
                      summary.totalMasukFormatted,
                      AppTheme.successColor,
                      'Masuk',
                    ),
                    _buildStat(
                      Icons.schedule_rounded,
                      summary.totalTelatFormatted,
                      AppTheme.warningColor,
                      'Telat',
                    ),
                    _buildStat(
                      Icons.nightlight_round,
                      summary.totalLemburFormatted,
                      AppTheme.infoColor,
                      'Lembur',
                    ),
                  ],
                ),
              ),
            ],
          ),
          iconColor: AppTheme.primaryAccent,
          collapsedIconColor: AppTheme.secondaryTextColor,
          children: [
            _buildDetailView(summary),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.tertiaryTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView(AttendanceSummary summary) {
    // Process records to get late, overtime, and absence details
    final lateDetails = <Map<String, dynamic>>[];
    final overtimeDetails = <Map<String, dynamic>>[];
    final absenceDetails = <Map<String, dynamic>>[];

    for (var record in summary.records) {
      if (record.hasData) {
        final daily = AttendanceService.processDailyAttendance(
          record,
          summary.employee.department,
        );
        
        final telat = daily['telat'] ?? 0;
        final lembur = daily['lembur'] ?? 0;

        // Collect late details
        if (telat > 0) {
          final checkInTime = AttendanceService.getCheckInTime(record);

          lateDetails.add({
            'date': record.date,
            'dayOfWeek': record.dayOfWeek ?? '-',
            'checkInTime': checkInTime ?? '-',
            'lateMinutes': telat,
          });
        }

        // Collect overtime details
        if (lembur > 0) {
          final checkOutTime = AttendanceService.getCheckOutTime(record);

          overtimeDetails.add({
            'date': record.date,
            'dayOfWeek': record.dayOfWeek ?? '-',
            'checkOutTime': checkOutTime ?? '-',
            'overtimeMinutes': lembur,
          });
        }
      } else if (record.isAbsence) {
        // Collect absence details (no data, not Saturday, not Sunday)
        absenceDetails.add({
          'date': record.date,
          'dayOfWeek': record.dayOfWeek ?? '-',
          'record': record, // Keep reference for notes editing
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Late Details Section
          _buildDetailSection(
            'Rincian Keterlambatan',
            Icons.schedule_rounded,
            AppTheme.warningColor,
            lateDetails.isEmpty
                ? [_buildEmptyState('Tidak ada keterlambatan')]
                : lateDetails.map((detail) {
                    final hours = detail['lateMinutes'] ~/ 60;
                    final minutes = detail['lateMinutes'] % 60;
                    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
                    
                    return _buildDetailRow(
                      'Tanggal ${detail['date'].day} (${detail['dayOfWeek']})',
                      'Masuk jam ${detail['checkInTime']}',
                      'Telat: $timeStr',
                      AppTheme.warningColor,
                    );
                  }).toList(),
          ),
          const SizedBox(height: 20),
          // Overtime Details Section
          _buildDetailSection(
            'Rincian Lembur',
            Icons.nightlight_round,
            AppTheme.infoColor,
            overtimeDetails.isEmpty
                ? [_buildEmptyState('Tidak ada lembur')]
                : overtimeDetails.map((detail) {
                    final hours = detail['overtimeMinutes'] ~/ 60;
                    final minutes = detail['overtimeMinutes'] % 60;
                    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
                    
                    return _buildDetailRow(
                      'Tanggal ${detail['date'].day} (${detail['dayOfWeek']})',
                      'Pulang jam ${detail['checkOutTime']}',
                      'Lembur: $timeStr',
                      AppTheme.infoColor,
                    );
                  }).toList(),
          ),
          const SizedBox(height: 20),
          // Absence/Sick Leave Details Section
          _buildDetailSection(
            'Rincian Izin/Sakit',
            Icons.sick_rounded,
            AppTheme.errorColor,
            absenceDetails.isEmpty
                ? [_buildEmptyState('Tidak ada izin/sakit')]
                : absenceDetails.map((detail) {
                    return _buildAbsenceRow(
                      'Tanggal ${detail['date'].day} (${detail['dayOfWeek']})',
                      detail['record'],
                    );
                  }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
    String date,
    String time,
    String duration,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppTheme.primaryTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.borderColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppTheme.successColor.withOpacity(0.6),
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenceRow(String date, AttendanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppTheme.primaryTextColor,
                  ),
                ),
              ),
              Icon(
                Icons.event_busy_rounded,
                size: 18,
                color: AppTheme.errorColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            key: ValueKey('absence_${record.date.toIso8601String()}'),
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: record.notes ?? '',
                selection: TextSelection.collapsed(offset: (record.notes ?? '').length),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Keterangan (Sakit/Izin)',
              hintStyle: TextStyle(
                fontSize: 12,
                color: AppTheme.tertiaryTextColor,
              ),
              filled: true,
              fillColor: AppTheme.surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.borderColor.withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.borderColor.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.errorColor,
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryTextColor,
            ),
            onChanged: (value) {
              record.notes = value;
            },
          ),
        ],
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
      // Note: All employees share column B for day-of-week and columns C-G for date
      // Note: nameCols and userIdCols are the same because UserID is on row 3, Name on row 2
      final employeeColumnMappings = [
        // Employee 1
        {
          'deptCols': [2, 3, 4, 5, 6], // C-G (also used for month detection from row 3)
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
          'deptCols': [13, 14, 15, 16, 17], // N-R (also used for month detection from row 3)
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
          'deptCols': [24, 25, 26, 27, 28], // Y-AC (also used for month detection from row 3)
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

    // Detect month and year from row 3 (index 2) using department columns
    int? year;
    int? month;
    for (int col in mapping['deptCols']) {
      if (sheet.rows.length > 2 && sheet.rows[2].length > col) {
        var cell = sheet.rows[2][col];
        if (cell != null && cell.value != null) {
          try {
            // Extract the actual value from CellValue wrapper
            final cellValue = cell.value;
            dynamic rawValue;
            
            try {
              // CellValue types have a 'value' property with the actual data
              rawValue = (cellValue as dynamic).value;
            } catch (e) {
              // Fallback if we can't access the value property
              rawValue = cellValue;
            }
            
            DateTime? parsedDate;
            
            if (rawValue is DateTime) {
              parsedDate = rawValue;
            } else if (rawValue != null) {
              // Try parsing string as date
              final valueStr = rawValue.toString();
              // Try various date formats
              try {
                parsedDate = DateTime.parse(valueStr);
              } catch (e) {
                // If direct parsing fails, try Excel date number
                final excelDate = double.tryParse(valueStr);
                if (excelDate != null) {
                  // Excel epoch: 1899-12-30
                  final excelEpoch = DateTime(1899, 12, 30);
                  parsedDate = excelEpoch.add(Duration(days: excelDate.toInt()));
                }
              }
            }
            
            if (parsedDate != null) {
              year = parsedDate.year;
              month = parsedDate.month;
              break;
            }
          } catch (e) {
            // Ignore parsing errors, continue to next column
          }
        }
      }
    }

    // Default to current year and month if not detected
    if (year == null || month == null) {
      final now = DateTime.now();
      year = now.year;
      month = now.month;
      if (kDebugMode) {
        print('[DEBUG] Could not detect month/year, using current: $year-$month');
      }
    }

    // Determine number of days in the detected month
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final maxRowIndex = 11 + daysInMonth; // row 12 = index 11 (day 1)
    
    if (kDebugMode) {
      print('[DEBUG] Detected month: $year-$month with $daysInMonth days, reading rows 12-${maxRowIndex + 1}');
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

    // Read attendance data dynamically based on detected month
    List<AttendanceRecord> records = [];
    if (kDebugMode) {
      print('[DEBUG] Reading attendance data for ${employee.name}');
    }
    for (int i = 11; i < maxRowIndex && i < sheet.rows.length; i++) {
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
      
      // Get date using detected month and year
      final dayNumber = i - 10; // row 12 = day 1, row 13 = day 2, etc.
      DateTime date;
      if (dayNumber >= 1 && dayNumber <= daysInMonth) {
        date = DateTime(year, month, dayNumber);
      } else {
        // Fallback
        date = DateTime(year, month, 1);
      }

      if (kDebugMode && dayOfWeek != null) {
        print('[DEBUG] Row ${i+1} (Day ${date.day}): dayOfWeek=$dayOfWeek');
      }

      // Extract time data using the mapping
      final jamMasukPagiCols = mapping['jamMasukPagi'] as List;
      final jamMasukSiangCols = mapping['jamMasukSiang'] as List;
      final jamMasukLemburCols = mapping['jamMasukLembur'] as List;
      
      String? jamMasukPagi1 = jamMasukPagiCols.isNotEmpty ? _getCellValue(row, jamMasukPagiCols[0]) : null;
      String? jamMasukPagi2 = jamMasukPagiCols.length > 1 ? _getCellValue(row, jamMasukPagiCols[1]) : null;
      String? jamKeluarPagi = _getCellValue(row, mapping['jamKeluarPagi']);
      String? jamMasukSiang1 = jamMasukSiangCols.isNotEmpty ? _getCellValue(row, jamMasukSiangCols[0]) : null;
      String? jamMasukSiang2 = jamMasukSiangCols.length > 1 ? _getCellValue(row, jamMasukSiangCols[1]) : null;
      String? jamKeluarSiang = _getCellValue(row, mapping['jamKeluarSiang']);
      String? jamMasukLembur1 = jamMasukLemburCols.isNotEmpty ? _getCellValue(row, jamMasukLemburCols[0]) : null;
      String? jamMasukLembur2 = jamMasukLemburCols.length > 1 ? _getCellValue(row, jamMasukLemburCols[1]) : null;
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
