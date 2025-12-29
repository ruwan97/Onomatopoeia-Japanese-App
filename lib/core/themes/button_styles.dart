import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class ButtonStyles {
  // Primary Button
  static ButtonStyle primary(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Secondary Button
  static ButtonStyle secondary(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
      elevation: 0,
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Outline Button
  static ButtonStyle outline(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline,
        width: 1,
      ),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Text Button
  static ButtonStyle text(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      textStyle: AppTextStyles.buttonMedium,
    );
  }

  // Small Button
  static ButtonStyle small(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: const Size(0, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.buttonSmall,
    );
  }

  // Large Button (Full Width)
  static ButtonStyle large(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      textStyle: AppTextStyles.buttonLarge,
    ).copyWith(
      minimumSize: WidgetStateProperty.all(
        const Size(double.infinity, 56),
      ),
    );
  }

  // Gradient Button (using AppColors helper methods)
  static ButtonStyle gradient(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 8,
      shadowColor: AppColors.withOpacity(AppColors.primary, 0.4),
      textStyle: AppTextStyles.buttonLarge.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryDark;
          }
          return Colors.transparent;
        },
      ),
    );
  }

  // Icon Button
  static ButtonStyle icon(BuildContext context) {
    return IconButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
    );
  }

  // Danger Button
  static ButtonStyle danger(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.error,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Success Button
  static ButtonStyle success(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.success,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Disabled Button
  static ButtonStyle disabled(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
      backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Glass Morphism Button
  static ButtonStyle glass(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      side: BorderSide(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1,
      ),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Helper method to create a glass button with custom color
  static ButtonStyle glassWithColor(BuildContext context, Color color, {double opacity = 0.1}) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: color.withValues(alpha: opacity),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      side: BorderSide(
        color: color.withValues(alpha: opacity * 2),
        width: 1,
      ),
      textStyle: AppTextStyles.buttonLarge,
    );
  }

  // Floating Action Button style
  static ButtonStyle fab(BuildContext context) {
    return IconButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
    );
  }

  // Pill-shaped button (rounded ends)
  static ButtonStyle pill(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      textStyle: AppTextStyles.buttonMedium,
    );
  }
}