import 'package:flutter/material.dart';

TextStyle _getPoppins({
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  double height = 1.5,
}) {
  try {
    // Try to import google_fonts dynamically
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      fontFamily: 'Poppins',
    );
  } catch (e) {
    // Fallback to default
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }
}

TextStyle _getNotoSansJp({
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
}) {
  try {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'NotoSansJP',
    );
  } catch (e) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

class AppTextStyles {
  // Headings
  static TextStyle headlineLarge = _getPoppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle headlineMedium = _getPoppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle headlineSmall = _getPoppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text
  static TextStyle bodyLarge = _getPoppins(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = _getPoppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodySmall = _getPoppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Caption
  static TextStyle caption = _getPoppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Button Text
  static TextStyle buttonLarge = _getPoppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle buttonMedium = _getPoppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle buttonSmall = _getPoppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Japanese Text Styles
  static TextStyle japaneseLarge = _getNotoSansJp(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static TextStyle japaneseMedium = _getNotoSansJp(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle japaneseSmall = _getNotoSansJp(
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  // Utility method to get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Utility method to get text style with custom font size
  static TextStyle withFontSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }
}