class AppConstants {
  static const String appName = 'Onomatopoeia Master';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn Japanese Onomatopoeia';

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);

  // API Endpoints (if any)
  static const String baseUrl = 'https://api.example.com';
  static const String soundsBaseUrl = 'https://sounds.example.com';

  // Local Storage Keys
  static const String themeKey = 'app_theme';
  static const String favoritesKey = 'favorites';
  static const String settingsKey = 'app_settings';
}

class OnomatopoeiaConstants {
  static const List<String> categories = [
    'Animal',
    'Nature',
    'Human',
    'Object',
    'Food',
    'Other',
  ];

  static const List<String> soundTypes = [
    'giongo',  // Sound words
    'gitaigo', // State/condition words
  ];

  static const Map<String, String> categoryDescriptions = {
    'Animal': 'Sounds made by animals',
    'Nature': 'Natural phenomena sounds',
    'Human': 'Human sounds and emotions',
    'Object': 'Sounds from objects',
    'Food': 'Eating and food-related sounds',
    'Other': 'Miscellaneous sounds',
  };
}