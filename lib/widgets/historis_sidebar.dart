import 'package:flutter/material.dart';

class HistorisSidebar extends StatefulWidget {
  final Function(int year, int month)? onDateSelected;

  const HistorisSidebar({
    super.key,
    this.onDateSelected,
  });

  @override
  State<HistorisSidebar> createState() => _HistorisSidebarState();
}

class _HistorisSidebarState extends State<HistorisSidebar> {
  int? _expandedYear;
  int? _selectedYear;
  int? _selectedMonth;

  // Generate years from 2023 to 2045
  final List<int> _years = List.generate(23, (index) => 2023 + index);

  // Month names in Indonesian
  final List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Pilih Periode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          // Year List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _years.length,
              itemBuilder: (context, index) {
                final year = _years[index];
                final isExpanded = _expandedYear == year;

                return Column(
                  children: [
                    // Year Item
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_expandedYear == year) {
                            _expandedYear = null;
                          } else {
                            _expandedYear = year;
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        color: isExpanded
                            ? const Color(0xFFF3F4F6)
                            : Colors.transparent,
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isExpanded
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isExpanded
                                ? const Color(0xFF6366F1)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),

                    // Month List (Expandable)
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        color: const Color(0xFFFAFAFA),
                        child: Column(
                          children: [
                            // Annual Recap item (month = 0)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedYear = year;
                                  _selectedMonth = 0;
                                });
                                widget.onDateSelected?.call(year, 0);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedYear == year && _selectedMonth == 0
                                      ? const Color(0xFFEEF2FF)
                                      : Colors.transparent,
                                  border: Border(
                                    left: BorderSide(
                                      color: _selectedYear == year && _selectedMonth == 0
                                          ? const Color(0xFF6366F1)
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Annual Recap',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _selectedYear == year && _selectedMonth == 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _selectedYear == year && _selectedMonth == 0
                                        ? const Color(0xFF6366F1)
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                            // Monthly items
                            ..._months.asMap().entries.map((entry) {
                              final monthIndex = entry.key;
                              final monthName = entry.value;
                              final isSelected = _selectedYear == year &&
                                  _selectedMonth == monthIndex + 1;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedYear = year;
                                    _selectedMonth = monthIndex + 1;
                                  });
                                  widget.onDateSelected?.call(year, monthIndex + 1);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFEEF2FF)
                                        : Colors.transparent,
                                    border: Border(
                                      left: BorderSide(
                                        color: isSelected
                                            ? const Color(0xFF6366F1)
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    monthName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFF6366F1)
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
