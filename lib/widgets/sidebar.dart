import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          
          // Logo Section
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6B7FFF),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B7FFF).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.insert_chart_outlined_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Menu Items
          _buildMenuItem(
            icon: Icons.grid_view_rounded,
            index: 0,
            tooltip: 'Rekap Absensi',
          ),
          
          const SizedBox(height: 16),
          
          _buildMenuItem(
            icon: Icons.history_rounded,
            index: 1,
            tooltip: 'Historis Absensi',
          ),
          
          const Spacer(),
          
          // Bottom Section
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF9CA3AF),
              ),
              iconSize: 24,
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF6B7FFF).withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(
                    color: const Color(0xFF6B7FFF).withOpacity(0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: isSelected 
                ? const Color(0xFF6B7FFF)
                : const Color(0xFF9CA3AF),
            size: 26,
          ),
        ),
      ),
    );
  }
}