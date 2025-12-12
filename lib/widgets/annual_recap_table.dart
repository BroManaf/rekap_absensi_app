import 'package:flutter/material.dart';
import '../models/annual_recap_data.dart';

class AnnualRecapTable extends StatelessWidget {
  final List<EmployeeAnnualData> employeeData;
  final int year;

  const AnnualRecapTable({
    super.key,
    required this.employeeData,
    required this.year,
  });

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
  Widget build(BuildContext context) {
    if (employeeData.isEmpty) {
      return Center(
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
              'Tidak ada data untuk tahun $year',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan simpan data bulanan terlebih dahulu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Info
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '${employeeData.length} karyawan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),

        // Scrollable Table
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _buildTable(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      children: [
        _buildHeaderRow(),
        ..._buildDataRows(),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
      ),
      children: [
        // Employee Name Column
        _buildHeaderCell('Nama Karyawan', width: 200, isSticky: true),
        // Month Columns
        ..._monthNames.map((month) => _buildMonthHeaderCell(month)),
      ],
    );
  }

  Widget _buildHeaderCell(String text, {double? width, bool isSticky = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: isSticky ? const Color(0xFFF8F9FA) : null,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Color(0xFF374151),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMonthHeaderCell(String monthName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      constraints: const BoxConstraints(minWidth: 180),
      child: Column(
        children: [
          Text(
            monthName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Telat',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Lembur',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildDataRows() {
    return employeeData.map((employee) {
      return TableRow(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        children: [
          // Employee Name
          _buildEmployeeNameCell(employee),
          // Month Data
          for (int month = 1; month <= 12; month++)
            _buildMonthDataCell(employee.getMonthData(month)),
        ],
      );
    }).toList();
  }

  Widget _buildEmployeeNameCell(EmployeeAnnualData employee) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            employee.userId,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthDataCell(MonthlyData data) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minWidth: 180, minHeight: 60),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      constraints: const BoxConstraints(minWidth: 180),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Masuk
          Expanded(
            child: _buildDataItem(
              data.masukFormatted,
              data.daysMasuk > 0 ? const Color(0xFF10B981) : Colors.grey[400]!,
            ),
          ),
          // Telat
          Expanded(
            child: _buildDataItem(
              data.telatFormatted,
              data.daysTelat > 0 ? const Color(0xFFF59E0B) : Colors.grey[400]!,
            ),
          ),
          // Lembur
          Expanded(
            child: _buildDataItem(
              data.lemburFormatted,
              data.daysLembur > 0 ? const Color(0xFF6366F1) : Colors.grey[400]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
