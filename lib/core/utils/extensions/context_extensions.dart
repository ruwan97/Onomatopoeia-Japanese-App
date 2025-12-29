import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Screen size helpers
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  // Responsive helpers
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  // Theme helpers
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Navigation helpers
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  // Dialog helpers
  Future<T?> showBottomSheet<T>(WidgetBuilder builder, {bool isDismissible = true}) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: true,
      isDismissible: isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<T?> showCustomDialog<T>(WidgetBuilder builder, {bool barrierDismissible = true}) {
    return showDialog<T>(
      context: this,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }

  // Snackbar helpers
  void showSuccessSnackbar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showErrorSnackbar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showInfoSnackbar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.secondary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Padding helpers
  EdgeInsets get defaultPadding => const EdgeInsets.all(16);
  EdgeInsets get horizontalPadding => const EdgeInsets.symmetric(horizontal: 16);
  EdgeInsets get verticalPadding => const EdgeInsets.symmetric(vertical: 16);

  // Animation helpers
  Duration get defaultAnimationDuration => const Duration(milliseconds: 300);
  Duration get fastAnimationDuration => const Duration(milliseconds: 150);
  Duration get slowAnimationDuration => const Duration(milliseconds: 500);
}