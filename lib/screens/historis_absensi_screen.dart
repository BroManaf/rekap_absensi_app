import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistorisAbsensiScreen extends StatelessWidget {
  const HistorisAbsensiScreen({super.key});

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
                  'Historis Absensi',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lihat riwayat data absensi karyawan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Content Area - Empty state with modern design
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.accentGradientStart,
                            AppTheme.accentGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryAccent.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        size: 60,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Historis Absensi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        'Fitur ini akan menampilkan riwayat lengkap data absensi karyawan dengan filter dan pencarian yang mudah',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.tertiaryTextColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.borderColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: AppTheme.infoColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Coming Soon',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryTextColor,
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
          ),
        ],
      ),
    );
  }
}