import 'dart:math';  // Add this import for sqrt
import 'package:flutter/material.dart';

class ColorHelper {
  static Color getContrastColor(Color backgroundColor) {
    // Calculate the luminance of the background color
    final luminance = backgroundColor.computeLuminance();

    // Return black for light backgrounds, white for dark backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color blend(Color color1, Color color2, double ratio) {
    // Use the new properties: r, g, b (float values 0.0-1.0)
    final r = (color1.r * (1 - ratio) + color2.r * ratio);
    final g = (color1.g * (1 - ratio) + color2.g * ratio);
    final b = (color1.b * (1 - ratio) + color2.b * ratio);
    final a = (color1.a * (1 - ratio) + color2.a * ratio);

    // Convert to Color with calculated alpha
    return Color.fromRGBO(
      (r * 255.0).round().clamp(0, 255),
      (g * 255.0).round().clamp(0, 255),
      (b * 255.0).round().clamp(0, 255),
      a,
    );
  }

  // Alternative blend method using Color.lerp (built-in)
  static Color blendLerp(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio)!;
  }

  // Alternative blend method using HSL for smoother transitions
  static Color blendHsl(Color color1, Color color2, double ratio) {
    final hsl1 = HSLColor.fromColor(color1);
    final hsl2 = HSLColor.fromColor(color2);

    final h = hsl1.hue * (1 - ratio) + hsl2.hue * ratio;
    final s = hsl1.saturation * (1 - ratio) + hsl2.saturation * ratio;
    final l = hsl1.lightness * (1 - ratio) + hsl2.lightness * ratio;
    final a = color1.a * (1 - ratio) + color2.a * ratio;

    return HSLColor.fromAHSL(a, h, s, l).toColor();
  }

  static String toHex(Color color, {bool withHash = true, bool includeAlpha = false}) {
    // Use the new properties r, g, b and convert to hex
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    if (includeAlpha) {
      final a = (color.a * 255).round();
      final hex = '${a.toRadixString(16).padLeft(2, '0')}'
          '${r.toRadixString(16).padLeft(2, '0')}'
          '${g.toRadixString(16).padLeft(2, '0')}'
          '${b.toRadixString(16).padLeft(2, '0')}';
      return withHash ? '#$hex' : hex;
    } else {
      final hex = '${r.toRadixString(16).padLeft(2, '0')}'
          '${g.toRadixString(16).padLeft(2, '0')}'
          '${b.toRadixString(16).padLeft(2, '0')}';
      return withHash ? '#$hex' : hex;
    }
  }

  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  // Helper method to get brightness value (0-1)
  static double getBrightness(Color color) {
    return color.computeLuminance();
  }

  // Check if a color is considered dark
  static bool isDark(Color color) {
    return getBrightness(color) < 0.5;
  }

  // Check if a color is considered light
  static bool isLight(Color color) {
    return getBrightness(color) > 0.5;
  }

  // Create a color with adjusted saturation
  static Color adjustSaturation(Color color, double saturation) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withSaturation(saturation.clamp(0.0, 1.0)).toColor();
  }

  // Create a color with adjusted hue
  static Color adjustHue(Color color, double hue) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue(hue % 360).toColor();
  }

  // Get complementary color
  static Color getComplementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  // Get analogous colors (neighbors on color wheel)
  static List<Color> getAnalogous(Color color, {int count = 3, double spread = 30}) {
    final hsl = HSLColor.fromColor(color);
    final colors = <Color>[];

    for (int i = 0; i < count; i++) {
      final hue = (hsl.hue + spread * (i - (count ~/ 2))) % 360;
      colors.add(hsl.withHue(hue).toColor());
    }

    return colors;
  }

  // Create a gradient color between two colors
  static List<Color> createGradient(Color start, Color end, int steps) {
    return List.generate(steps, (index) {
      final ratio = index / (steps - 1);
      return Color.lerp(start, end, ratio)!;
    });
  }

  // Convert color to Material Color
  static MaterialColor toMaterialColor(Color color) {
    // Use toARGB32() instead of .value
    return MaterialColor(color.toARGB32(), {
      50: lighten(color, 0.4),
      100: lighten(color, 0.3),
      200: lighten(color, 0.2),
      300: lighten(color, 0.1),
      400: color,
      500: darken(color, 0.1),
      600: darken(color, 0.2),
      700: darken(color, 0.3),
      800: darken(color, 0.4),
      900: darken(color, 0.5),
    });
  }

  // Helper method to extract RGB values as integers (0-255)
  static (int r, int g, int b) getRgbValues(Color color) {
    return (
    (color.r * 255).round(),
    (color.g * 255).round(),
    (color.b * 255).round(),
    );
  }

  // Helper method to extract RGBA values as floats (0.0-1.0)
  static (double r, double g, double b, double a) getRgbaFloatValues(Color color) {
    return (color.r, color.g, color.b, color.a);
  }

  // Create a color from RGB values (0-255)
  static Color fromRgb(int r, int g, int b, [double opacity = 1.0]) {
    return Color.fromRGBO(
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
      opacity,
    );
  }

  // Create a color from RGBA values (0-255)
  static Color fromRgba(int r, int g, int b, int a) {
    return Color.fromARGB(
      a.clamp(0, 255),
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
    );
  }

  // Create a color from HSL values
  static Color fromHsl(double hue, double saturation, double lightness, [double opacity = 1.0]) {
    return HSLColor.fromAHSL(opacity, hue, saturation, lightness).toColor();
  }

  // Get color alpha value as integer (0-255)
  static int getAlphaInt(Color color) {
    return (color.a * 255).round().clamp(0, 255);
  }

  // Get color alpha value as float (0.0-1.0)
  static double getAlphaFloat(Color color) {
    return color.a;
  }

  // Create color with alpha (float 0.0-1.0)
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  // Get the ARGB32 integer value
  static int toArgb32(Color color) {
    return color.toARGB32();
  }

  // Create color from ARGB32 integer
  static Color fromArgb32(int argb) {
    return Color(argb);
  }

  // Check if two colors are approximately equal
  static bool approximatelyEqual(Color color1, Color color2, {double tolerance = 0.01}) {
    return (color1.r - color2.r).abs() < tolerance &&
        (color1.g - color2.g).abs() < tolerance &&
        (color1.b - color2.b).abs() < tolerance &&
        (color1.a - color2.a).abs() < tolerance;
  }

  // Calculate color difference (Euclidean distance in RGBA space)
  static double colorDistance(Color color1, Color color2) {
    final dr = color1.r - color2.r;
    final dg = color1.g - color2.g;
    final db = color1.b - color2.b;
    final da = color1.a - color2.a;

    return sqrt(dr * dr + dg * dg + db * db + da * da);
  }

  // Calculate perceptual color difference using CIEDE2000 (simplified)
  static double perceptualColorDifference(Color color1, Color color2) {
    // Convert to LAB color space (simplified approximation)
    final lab1 = _rgbToLab(color1.r, color1.g, color1.b);
    final lab2 = _rgbToLab(color2.r, color2.g, color2.b);

    final dl = lab1.$1 - lab2.$1;
    final da = lab1.$2 - lab2.$2;
    final db = lab1.$3 - lab2.$3;

    // Euclidean distance in LAB space (better for perceptual difference)
    return sqrt(dl * dl + da * da + db * db);
  }

  // Helper: Convert RGB (0-1) to LAB color space (simplified)
  static (double l, double a, double b) _rgbToLab(double r, double g, double b) {
    // Simple approximation - in reality this involves conversion to XYZ first
    // For simplicity, we'll use a basic conversion
    final l = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    final a = 1.4749 * (0.2213 * r - 0.3390 * g + 0.1177 * b) + 128;
    final bValue = 0.6245 * (0.1949 * r + 0.6057 * g - 0.8006 * b) + 128;

    return (l * 100, a - 128, bValue - 128);
  }

  // Get color temperature (warm/cool) - returns value from -1 (cool) to 1 (warm)
  static double getColorTemperature(Color color) {
    final (r, g, b, _) = getRgbaFloatValues(color);

    // Simple temperature calculation based on red-blue balance
    final temperature = (r - b) / (r + g + b + 0.001); // Avoid division by zero
    return temperature.clamp(-1.0, 1.0);
  }

  // Check if color is warm (red/orange/yellow tones)
  static bool isWarm(Color color) {
    return getColorTemperature(color) > 0.1;
  }

  // Check if color is cool (blue/green/purple tones)
  static bool isCool(Color color) {
    return getColorTemperature(color) < -0.1;
  }

  // Generate random color
  static Color random({double alpha = 1.0}) {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      alpha,
    );
  }

  // Generate random color within a specific hue range
  static Color randomWithHue(double hue, {double range = 30, double saturation = 0.8, double lightness = 0.6, double alpha = 1.0}) {
    final random = Random();
    final hueVariation = (random.nextDouble() * 2 - 1) * range; // -range to +range
    final actualHue = (hue + hueVariation) % 360;

    return fromHsl(actualHue, saturation, lightness, alpha);
  }
}