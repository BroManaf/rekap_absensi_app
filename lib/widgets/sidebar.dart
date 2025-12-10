import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;

  const Sidebar({
    super.key,
    required this. selectedIndex,
    required this. onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.dashboard_rounded,
                color: Colors. white,
                size: 24,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Menu Items
          _buildMenuItem(
            icon: Icons.assessment_outlined,
            index: 0,
            tooltip: 'Rekap Absensi',
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            icon: Icons.file_download_outlined,
            index: 1,
            tooltip: 'Export Excel',
          ),
          
          const SizedBox(height: 8),
          
          _buildMenuItem(
            icon: Icons.history_rounded,
            index: 2,
            tooltip: 'Historis Absensi',
          ),
          
          const Spacer(),
          
          // Bottom Section (Optional - bisa untuk settings atau profile)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF9CA3AF),
              ),
              onPressed: () {},
              tooltip: 'Settings',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required int index,
    required String tooltip,
  }) {
    final isSelected = selectedIndex == index;
    
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: InkWell(
        onTap: () => onMenuSelected(index),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF6366F1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected 
                ? Colors.white 
                : const Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
      ),
    );
  }
}