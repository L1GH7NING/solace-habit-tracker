import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ☀️ LIGHT THEME (Unchanged)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimary,
      error: Colors.red.shade600,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      secondaryContainer: AppColors.secondaryContainer,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.beVietnamPro(
        fontSize: 14,
        color: AppColors.textSecondary,
        letterSpacing: -0.5,
      ),
      labelLarge: GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        textStyle: GoogleFonts.beVietnamPro(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: GoogleFonts.beVietnamPro(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    extensions: [
      AcrylicTheme(
        backgroundColor: Colors.white.withOpacity(0.65),
        borderColor: Colors.black.withOpacity(0.08), // Dark stroke for light mode
        shadowColor: Colors.black.withOpacity(0.06),
      ),
    ],
  );

  // 🌙 DARK THEME (New and tailored to your AppColors)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark background

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary, // Brand color is bright enough for dark mode
      onPrimary: Colors.white,
      secondary: AppColors.secondary, // Light secondary color also works well
      onSecondary: AppColors.textPrimary, // Dark text provides great contrast on light secondary
      error: Colors.red.shade600,
      onError: Colors.white,
      surface: const Color(0xFF1E1E1E), // Elevated surfaces like cards
      onSurface: const Color(0xFFE6E6E6), // Softer white for primary text
      onSurfaceVariant: AppColors.onSurfaceVariant, // Re-using for subtle text
      secondaryContainer: AppColors.primary.withOpacity(0.15), // Dark tinted container
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFE6E6E6), // Use onSurface color
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFE6E6E6), // Use onSurface color
      ),
      bodyMedium: GoogleFonts.beVietnamPro(
        fontSize: 14,
        color: AppColors.onSurfaceVariant, // Use onSurfaceVariant color
        letterSpacing: -0.5,
      ),
      labelLarge: GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        textStyle: GoogleFonts.beVietnamPro(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary, // Brand color is vibrant enough
        textStyle: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C), // Dark fill for text fields
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: GoogleFonts.beVietnamPro(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E), // Match the surface color
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    extensions: [
      AcrylicTheme(
        backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.7),
        borderColor: Colors.white.withOpacity(0.12), // Light stroke for dark mode
        shadowColor: Colors.black.withOpacity(0.4),
      ),
    ],
  );
}

// Add this class at the bottom of your app_theme.dart
class AcrylicTheme extends ThemeExtension<AcrylicTheme> {
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;

  const AcrylicTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
  });

  @override
  ThemeExtension<AcrylicTheme> copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? shadowColor,
  }) {
    return AcrylicTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<AcrylicTheme> lerp(ThemeExtension<AcrylicTheme>? other, double t) {
    if (other is! AcrylicTheme) return this;
    return AcrylicTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}