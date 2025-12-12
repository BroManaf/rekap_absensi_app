import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/attendance_summary.dart';
import '../models/attendance_record.dart';
import '../services/attendance_service.dart';
import '../services/attendance_storage_service.dart';
import '../utils/date_utils.dart' as date_utils;

class HistorisAbsensiScreen extends StatefulWidget {
  final int? selectedYear;
  final int? selectedMonth;

  const HistorisAbsensiScreen({
    super.key,
    this.selectedYear,
    this.selectedMonth,
  });

  @override
  State<HistorisAbsensiScreen> createState() => HistorisAbsensiScreenState();
}

class HistorisAbsensiScreenState extends State<HistorisAbsensiScreen> {
  List<AttendanceSummary> _summaries = [];
  bool _isLoading = false;
  int? _currentYear;
  int? _currentMonth;
  final Set<int> _expandedRows = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Annual Recap identifier (same as in HistorisSidebar)
  static const int annualRecapMonth = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedYear != null && widget.selectedMonth != null) {
      loadData(widget.selectedYear!, widget.selectedMonth!);
    }
  }

  bool get _isAnnualRecap => _currentMonth == annualRecapMonth;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AttendanceSummary> get _filteredSummaries {
    if (_searchQuery.isEmpty) {
      return _summaries;
    }
    
    final query = _searchQuery.toLowerCase();
    return _summaries.where((summary) {
      final userId = summary.employee.userId.toLowerCase();
      final name = summary.employee.name.toLowerCase();
      return userId.contains(query) || name.contains(query);
    }).toList();
  }

  Future<void> loadData(int year, int month) async {
    setState(() {
      _isLoading = true;
      _currentYear = year;
      _currentMonth = month;
      _expandedRows.clear();
      _searchQuery = '';
      _searchController.clear();
    });

    // For Annual Recap (month = 0), just set empty data
    if (month == annualRecapMonth) {
      setState(() {
        _summaries = [];
        _isLoading = false;
      });
      return;
    }

    final data = await AttendanceStorageService.loadAttendanceData(
      year: year,
      month: month,
    );

    setState(() {
      _summaries = data ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historis Absensi',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentYear != null && _currentMonth != null
                        ? _isAnnualRecap
                            ? 'Annual Recap $_currentYear'
                            : 'Data absensi ${date_utils.DateUtils.getMonthName(_currentMonth!)} $_currentYear'
                        : 'Pilih periode dari sidebar untuk melihat data',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Content Area
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Memuat data...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : _summaries.isEmpty
                    ? Container(
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentYear != null && _currentMonth != null
                                    ? _isAnnualRecap
                                        ? 'Annual Recap $_currentYear'
                                        : 'Tidak ada data untuk ${date_utils.DateUtils.getMonthName(_currentMonth!)} $_currentYear'
                                    : 'Pilih periode dari sidebar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentYear != null && _currentMonth != null
                                    ? _isAnnualRecap
                                        ? 'Konten Annual Recap belum tersedia'
                                        : 'Silakan upload dan simpan data terlebih dahulu'
                                    : 'Klik tahun dan bulan di sidebar untuk melihat data historis',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
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
                                      Text(
                                        '${date_utils.DateUtils.getMonthName(_currentMonth!)} $_currentYear',
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
                                        onPressed: _downloadExcelFile,
                                        icon: const Icon(Icons.download, size: 16),
                                        label: const Text('Download Excel'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: _deleteData,
                                        icon: const Icon(Icons.delete, size: 16),
                                        label: const Text('Hapus Data'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
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
                              const SizedBox(height: 20),
                              // Search Field
                              Container(
                                constraints: const BoxConstraints(maxWidth: 400),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Cari berdasarkan User ID atau Nama Karyawan...',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[400],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _searchQuery = '';
                                                _searchController.clear();
                                              });
                                            },
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6366F1),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                              if (_searchQuery.isNotEmpty && _filteredSummaries.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Tidak ada hasil yang cocok dengan pencarian "$_searchQuery"',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ),
                              if (_searchQuery.isNotEmpty && _filteredSummaries.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Menampilkan ${_filteredSummaries.length} dari ${_summaries.length} karyawan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              _buildSummaryTable(),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
    final summariesToDisplay = _filteredSummaries;
    
    return Column(
      children: [
        // Table Header
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const SizedBox(
                width: 80,
                child: Text(
                  'User ID',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                flex: 2,
                child: Text(
                  'Nama Karyawan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  'Telat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  'Lembur',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Rows
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: summariesToDisplay.length,
          itemBuilder: (context, index) {
            final summary = summariesToDisplay[index];
            return _buildExpandableTableRow(summary, index);
          },
        ),
      ],
    );
  }

  Widget _buildExpandableTableRow(AttendanceSummary summary, int index) {
    final isExpanded = _expandedRows.contains(index);
    final isEven = index % 2 == 0;
    
    return Column(
      children: [
        // Table Row
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedRows.remove(index);
              } else {
                _expandedRows.add(index);
              }
            });
          },
          hoverColor: const Color(0xFFF3F4F6),
          child: Container(
            decoration: BoxDecoration(
              color: isEven ? Colors.white : const Color(0xFFFAFAFA),
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // User ID
                SizedBox(
                  width: 80,
                  child: Text(
                    summary.employee.userId,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Nama Karyawan + Department (stacked)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        summary.employee.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary.employee.department.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Masuk
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.green[600]),
                      const SizedBox(width: 4),
                      Text(
                        summary.totalMasukFormatted,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Telat
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        summary.totalTelatFormatted,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Lembur
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.nights_stay, size: 14, color: Colors.indigo[600]),
                      const SizedBox(width: 4),
                      Text(
                        summary.totalLemburFormatted,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.indigo[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expanded Details
        if (isExpanded)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: _buildDetailView(summary),
          ),
      ],
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
          'record': record, // Keep reference for displaying notes
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Late Details Section
          _buildMinimalistTableSection(
            'Rincian Keterlambatan',
            Icons.warning_amber_rounded,
            Colors.orange[700]!,
            Colors.orange[50]!,
            lateDetails.isEmpty
                ? null
                : lateDetails.map((detail) {
                    final hours = detail['lateMinutes'] ~/ 60;
                    final minutes = detail['lateMinutes'] % 60;
                    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
                    
                    return {
                      'date': '${detail['date'].day}',
                      'day': detail['dayOfWeek'] as String,
                      'time': detail['checkInTime'] as String,
                      'duration': timeStr,
                    };
                  }).toList(),
            ['Tgl', 'Hari', 'Jam Masuk', 'Durasi'],
            'Tidak ada keterlambatan',
          ),
          const SizedBox(height: 16),
          // Overtime Details Section
          _buildMinimalistTableSection(
            'Rincian Lembur',
            Icons.nights_stay,
            Colors.indigo[700]!,
            Colors.indigo[50]!,
            overtimeDetails.isEmpty
                ? null
                : overtimeDetails.map((detail) {
                    final hours = detail['overtimeMinutes'] ~/ 60;
                    final minutes = detail['overtimeMinutes'] % 60;
                    final timeStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
                    
                    return {
                      'date': '${detail['date'].day}',
                      'day': detail['dayOfWeek'] as String,
                      'time': detail['checkOutTime'] as String,
                      'duration': timeStr,
                    };
                  }).toList(),
            ['Tgl', 'Hari', 'Jam Pulang', 'Durasi'],
            'Tidak ada lembur',
          ),
          const SizedBox(height: 16),
          // Absence/Sick Leave Details Section
          _buildAbsenceTableSection(
            'Rincian Izin/Sakit',
            Icons.sick,
            Colors.red[700]!,
            absenceDetails,
          ),
        ],
      ),
    );
  }

  /// Build a minimalist table section for late/overtime details
  Widget _buildMinimalistTableSection(
    String title,
    IconData icon,
    Color color,
    Color bgColor,
    List<Map<String, String>>? data,
    List<String> headers,
    String emptyMessage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Table or Empty State
        if (data == null || data.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 18),
                const SizedBox(width: 8),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          headers[0],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          headers[1],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          headers[2],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          headers[3],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Rows
                ...data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final isLast = index == data.length - 1;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                      border: isLast ? null : Border(
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      borderRadius: isLast ? const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ) : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            row['date']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            row['day']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row['time']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            row['duration']!,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
      ],
    );
  }

  /// Build absence/sick leave table section with notes (read-only)
  Widget _buildAbsenceTableSection(
    String title,
    IconData icon,
    Color color,
    List<Map<String, dynamic>> absenceDetails,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Table or Empty State
        if (absenceDetails.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 18),
                const SizedBox(width: 8),
                Text(
                  'Tidak ada izin/sakit',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          'Tgl',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Hari',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Keterangan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Rows
                ...absenceDetails.asMap().entries.map((entry) {
                  final index = entry.key;
                  final detail = entry.value;
                  final record = detail['record'] as AttendanceRecord;
                  final isLast = index == absenceDetails.length - 1;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                      border: isLast ? null : Border(
                        bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      borderRadius: isLast ? const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ) : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${detail['date'].day}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            detail['dayOfWeek'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            record.notes?.isEmpty ?? true ? '-' : record.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _downloadExcelFile() async {
    if (_currentYear == null || _currentMonth == null) {
      return;
    }

    try {
      // Get the Excel file from database
      final excelData = await AttendanceStorageService.getExcelFile(
        year: _currentYear!,
        month: _currentMonth!,
      );

      if (excelData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('File Excel tidak tersedia untuk periode ini'),
              backgroundColor: Colors.orange[600],
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Get the bytes and filename with safe type checking
      final bytesData = excelData['bytes'];
      if (bytesData == null || bytesData is! List<int>) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Format file Excel tidak valid'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      final bytes = bytesData as List<int>;
      final originalFilename = excelData['filename'] as String?;
      
      if (kDebugMode) {
        debugPrint('[HistorisScreen] Excel file ready for download: ${bytes.length} bytes, filename: $originalFilename');
      }
      
      // Generate a default filename if not available
      final defaultFilename = 'Absensi_${date_utils.DateUtils.getMonthName(_currentMonth!)}_$_currentYear.xlsx';
      final filename = originalFilename ?? defaultFilename;

      // Let user choose where to save the file
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan File Excel',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (savePath == null) {
        // User cancelled the save dialog
        return;
      }

      // Write the file to the selected location
      final file = File(savePath);
      await file.writeAsBytes(bytes);
      
      if (kDebugMode) {
        final savedFile = File(savePath);
        final savedSize = await savedFile.length();
        debugPrint('[HistorisScreen] File written to: $savePath, size: $savedSize bytes (original: ${bytes.length} bytes)');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File Excel berhasil disimpan: ${path.basename(savePath)}'),
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
            content: Text('Gagal menyimpan file: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteData() async {
    if (_currentYear == null || _currentMonth == null) {
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua data absensi untuk ${date_utils.DateUtils.getMonthName(_currentMonth!)} $_currentYear?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    // Delete the data
    final success = await AttendanceStorageService.deleteAttendanceData(
      year: _currentYear!,
      month: _currentMonth!,
    );

    if (mounted) {
      if (success) {
        // Clear the current data
        setState(() {
          _summaries = [];
          _currentYear = null;
          _currentMonth = null;
          _expandedRows.clear();
          _searchQuery = '';
          _searchController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data berhasil dihapus'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menghapus data'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
