import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // 🎨 Background
    scaffoldBackgroundColor: AppColors.background,

    // 🌈 Proper Color System (VERY IMPORTANT)
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,

      secondary: AppColors.secondary,
      onSecondary: Colors.white,

      error: Colors.red,
      onError: Colors.white,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      secondaryContainer: AppColors.secondaryContainer
    ),

    // 🔤 Typography
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
      ),
      labelLarge: GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // 🔘 Elevated Button (Primary CTA)
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

    // 🪄 Text Button (Secondary action)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),

    // 🔍 Input (Search bar style from your UI)
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
  );
}
