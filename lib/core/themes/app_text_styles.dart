import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Caption
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Button Text
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle buttonSmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Japanese Text Styles
  static TextStyle japaneseLarge = const TextStyle(
    fontFamily: 'NotoSansJP',
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static TextStyle japaneseMedium = const TextStyle(
    fontFamily: 'NotoSansJP',
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle japaneseSmall = const TextStyle(
    fontFamily: 'NotoSansJP',
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
}