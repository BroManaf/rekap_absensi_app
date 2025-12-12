import 'package:flutter/material.dart';
import '../models/annual_recap.dart';
import '../services/annual_recap_service.dart';

class AnnualRecapScreen extends StatefulWidget {
  final int? selectedYear;

  const AnnualRecapScreen({
    super.key,
    this.selectedYear,
  });

  @override
  State<AnnualRecapScreen> createState() => _AnnualRecapScreenState();
}

class _AnnualRecapScreenState extends State<AnnualRecapScreen> {
  List<EmployeeAnnualRecap> _recaps = [];
  bool _isLoading = false;
  int? _currentYear;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Month names in Indonesian (abbreviated)
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedYear != null) {
      loadData(widget.selectedYear!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EmployeeAnnualRecap> get _filteredRecaps {
    if (_searchQuery.isEmpty) {
      return _recaps;
    }

    final query = _searchQuery.toLowerCase();
    return _recaps.where((recap) {
      final userId = recap.employee.userId.toLowerCase();
      final name = recap.employee.name.toLowerCase();
      return userId.contains(query) || name.contains(query);
    }).toList();
  }

  Future<void> loadData(int year) async {
    setState(() {
      _isLoading = true;
      _currentYear = year;
      _searchQuery = '';
      _searchController.clear();
    });

    final data = await AnnualRecapService.getAnnualRecap(year);

    setState(() {
      _recaps = data;
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
                    'Annual Recap',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentYear != null
                        ? 'Rekap tahunan karyawan tahun $_currentYear'
                        : 'Pilih tahun dari sidebar untuk melihat data',
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
                : _recaps.isEmpty
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
                                _currentYear != null
                                    ? 'Tidak ada data untuk tahun $_currentYear'
                                    : 'Pilih tahun dari sidebar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _currentYear != null
                                    ? 'Belum ada data absensi yang tersimpan untuk tahun ini'
                                    : 'Klik tahun di sidebar untuk melihat annual recap',
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
                                        'Annual Recap $_currentYear',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Text(
                                        'Ringkasan kehadiran bulanan per karyawan',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${_recaps.length} karyawan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
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
                                    hintText: 'Cari berdasarkan User ID atau Nama...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13,
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
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _searchQuery = '';
                                                _searchController.clear();
                                              });
                                            },
                                          )
                                        : null,
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
                                      borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                              if (_searchQuery.isNotEmpty && _filteredRecaps.isEmpty)
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
                              if (_searchQuery.isNotEmpty && _filteredRecaps.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Menampilkan ${_filteredRecaps.length} dari ${_recaps.length} karyawan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              _buildAnnualRecapTable(),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualRecapTable() {
    final recapsToDisplay = _filteredRecaps;
    
    // Calculate total width: 200 (name) + 8 (spacing) + 12 * 90 (months) = 1288px
    const double totalTableWidth = 200 + 8 + (12 * 90);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalTableWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Employee Name Column
                  const SizedBox(
                    width: 200,
                    child: Text(
                      'Nama',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Month Columns
                  for (int i = 0; i < 12; i++)
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _monthNames[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.grey[800],
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
              itemCount: recapsToDisplay.length,
              itemBuilder: (context, index) {
                final recap = recapsToDisplay[index];
                return _buildTableRow(recap, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(EmployeeAnnualRecap recap, int index) {
    final isEven = index % 2 == 0;

    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.white : const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Name Column
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recap.employee.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recap.employee.userId,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Month Data Columns
          for (int month = 1; month <= 12; month++)
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildMonthCell(recap.getMonthData(month)),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthCell(MonthlyData? data) {
    if (data == null || !data.hasData) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Days present (Masuk)
          Row(
            children: [
              Icon(Icons.check_circle, size: 10, color: Colors.green[600]),
              const SizedBox(width: 4),
              Text(
                '${data.daysMasuk}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Days late (Telat)
          Row(
            children: [
              Icon(Icons.access_time, size: 10, color: Colors.orange[600]),
              const SizedBox(width: 4),
              Text(
                '${data.daysTelat}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Days overtime (Lembur)
          Row(
            children: [
              Icon(Icons.nights_stay, size: 10, color: Colors.indigo[600]),
              const SizedBox(width: 4),
              Text(
                '${data.daysLembur}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
