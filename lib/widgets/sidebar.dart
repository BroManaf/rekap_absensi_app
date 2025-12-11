import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onMenuSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        border: Border(
          right: BorderSide(
            color: AppTheme.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          
          // Logo Section with gradient
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentGradientStart,
                  AppTheme.accentGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryAccent.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.checklist_rounded,
              color: AppTheme.primaryTextColor,
              size: 26,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Menu Items
          _buildMenuItem(
            icon: Icons.dashboard_rounded,
            activeIcon: Icons.dashboard,
            index: 0,
            tooltip: 'Rekap Absensi',
          ),
          
          const SizedBox(height: 12),
          
          _buildMenuItem(
            icon: Icons.history_rounded,
            activeIcon: Icons.history,
            index: 1,
            tooltip: 'Historis Absensi',
          ),
          
          const Spacer(),
          
          // Bottom Section - Settings
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Settings functionality can be implemented here
                  // For now, this is a placeholder
                },
                child: Tooltip(
                  message: 'Settings',
                  preferBelow: false,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppTheme.secondaryTextColor,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String tooltip,
  }) {
    final isSelected = widget.selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onMenuSelected(index),
        child: Tooltip(
          message: tooltip,
          preferBelow: false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentGradientStart,
                        AppTheme.accentGradientEnd,
                      ],
                    )
                  : null,
              color: !isSelected && isHovered
                  ? AppTheme.hoverColor
                  : !isSelected
                      ? Colors.transparent
                      : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryAccent.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppTheme.primaryTextColor
                  : isHovered
                      ? AppTheme.primaryTextColor
                      : AppTheme.secondaryTextColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}