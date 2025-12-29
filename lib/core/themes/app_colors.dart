import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors with gradients
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5248E5);
  static const Color primaryLight = Color(0xFF8A84FF);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryDark = Color(0xFFE64A6A);
  static const Color secondaryLight = Color(0xFFFF8AA4);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF36D1DC);
  static const Color tertiaryDark = Color(0xFF1DB5C0);
  static const Color tertiaryLight = Color(0xFF5FE7F2);

  // Accent Colors
  static const Color accent1 = Color(0xFFFFB74D);
  static const Color accent2 = Color(0xFF4CAF50);
  static const Color accent3 = Color(0xFF9C27B0);

  // Neutral Colors
  static const Color black = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Category Colors
  static const Color animalColor = Color(0xFFFFB74D);
  static const Color natureColor = Color(0xFF4CAF50);
  static const Color humanColor = Color(0xFFE91E63);
  static const Color objectColor = Color(0xFF9C27B0);
  static const Color foodColor = Color(0xFFFF5722);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, accent1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF8BC34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism effect
  static Color glassWhite = Colors.white.withOpacity(0.1);
  static Color glassBlack = Colors.black.withOpacity(0.1);

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 15,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];
}