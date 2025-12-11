import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Colors - Minimalist & Aesthetic
  static const Color primaryBackground = Color(0xFF0F1419); // Very dark blue-gray
  static const Color secondaryBackground = Color(0xFF1A1F2E); // Dark blue-gray
  static const Color surfaceColor = Color(0xFF1E2530); // Slightly lighter surface
  static const Color cardColor = Color(0xFF242B3D); // Card background
  
  // Accent Colors
  static const Color primaryAccent = Color(0xFF5B8DEF); // Soft blue
  static const Color secondaryAccent = Color(0xFF7C3AED); // Purple
  static const Color accentGradientStart = Color(0xFF667EEA); // Blue-purple gradient start
  static const Color accentGradientEnd = Color(0xFF764BA2); // Purple gradient end
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Orange/Amber
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color infoColor = Color(0xFF3B82F6); // Blue
  
  // Text Colors
  static const Color primaryTextColor = Color(0xFFF9FAFB); // Almost white
  static const Color secondaryTextColor = Color(0xFF9CA3AF); // Gray
  static const Color tertiaryTextColor = Color(0xFF6B7280); // Darker gray
  
  // Border & Divider
  static const Color borderColor = Color(0xFF374151); // Dark border
  static const Color dividerColor = Color(0xFF2D3748); // Subtle divider
  
  // Hover & Active States
  static const Color hoverColor = Color(0xFF2A3441);
  static const Color activeColor = Color(0xFF303947);
  
  // Create the main dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBackground,
      primaryColor: primaryAccent,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: surfaceColor,
        background: primaryBackground,
        error: errorColor,
        onPrimary: primaryTextColor,
        onSecondary: primaryTextColor,
        onSurface: primaryTextColor,
        onBackground: primaryTextColor,
        onError: primaryTextColor,
      ),
      
      // Card Theme
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 4,
        shadowColor: Color(0x4D000000), // Black with 30% opacity
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryTextColor),
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: tertiaryTextColor,
          fontSize: 12,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        hintStyle: const TextStyle(color: tertiaryTextColor),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: primaryTextColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTextColor,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: secondaryTextColor,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
    );
  }
  
  // Gradient decorations
  static BoxDecoration get gradientBackground {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryBackground,
          secondaryBackground,
        ],
      ),
    );
  }
  
  static BoxDecoration get accentGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentGradientStart,
          accentGradientEnd,
        ],
      ),
    );
  }
  
  // Glass morphism effect
  static BoxDecoration glassMorphism({double opacity = 0.1}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  // Card shadow
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  // Subtle card shadow
  static List<BoxShadow> get subtleCardShadow {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
