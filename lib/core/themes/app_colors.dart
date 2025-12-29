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
  static const Color vehicleColor = Color(0xFF2196F3);
  static const Color musicColor = Color(0xFF009688);
  static const Color technologyColor = Color(0xFF607D8B);

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

  // Glassmorphism effect - Using withValues() instead of withOpacity()
  static Color get glassWhite => const Color(0xFFFFFFFF).withValues(alpha: 0.1);
  static Color get glassBlack => const Color(0xFF000000).withValues(alpha: 0.1);

  // Alternative approach: define as methods
  static Color glassWhiteOpacity(double opacity) => const Color(0xFFFFFFFF).withValues(alpha: opacity);
  static Color glassBlackOpacity(double opacity) => const Color(0xFF000000).withValues(alpha: opacity);

  // Common opacity values as static getters
  static Color get glassWhite10 => const Color(0xFFFFFFFF).withValues(alpha: 0.1);
  static Color get glassWhite20 => const Color(0xFFFFFFFF).withValues(alpha: 0.2);
  static Color get glassWhite30 => const Color(0xFFFFFFFF).withValues(alpha: 0.3);
  static Color get glassBlack10 => const Color(0xFF000000).withValues(alpha: 0.1);
  static Color get glassBlack20 => const Color(0xFF000000).withValues(alpha: 0.2);
  static Color get glassBlack30 => const Color(0xFF000000).withValues(alpha: 0.3);

  // Shadows - Using withValues() in the getter
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.1),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.3),
      blurRadius: 15,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  // Helper method to create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Common semi-transparent colors
  static Color get primary10 => primary.withValues(alpha: 0.1);
  static Color get primary20 => primary.withValues(alpha: 0.2);
  static Color get primary30 => primary.withValues(alpha: 0.3);
  static Color get primary40 => primary.withValues(alpha: 0.4);

  static Color get secondary10 => secondary.withValues(alpha: 0.1);
  static Color get secondary20 => secondary.withValues(alpha: 0.2);
  static Color get secondary30 => secondary.withValues(alpha: 0.3);

  static Color get success10 => success.withValues(alpha: 0.1);
  static Color get warning10 => warning.withValues(alpha: 0.1);
  static Color get error10 => error.withValues(alpha: 0.1);
}