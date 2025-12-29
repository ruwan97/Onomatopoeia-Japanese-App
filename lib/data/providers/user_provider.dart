import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _username = 'Learner';
  String _email = 'learner@example.com';
  int _learnedWords = 0;
  int _favoriteCount = 0;
  int _streakDays = 0;
  int _userLevel = 1;
  double _totalMastery = 0.0;
  DateTime _lastLogin = DateTime.now();

  static const String _userKey = 'user_data';

  UserProvider() {
    _loadUserData();
  }

  // Getters
  String get username => _username;
  String get email => _email;
  int get learnedWords => _learnedWords;
  int get favoriteCount => _favoriteCount;
  int get streakDays => _streakDays;
  int get userLevel => _userLevel;
  double get totalMastery => _totalMastery;
  DateTime get lastLogin => _lastLogin;

  // Load user data from shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'Learner';
    _email = prefs.getString('email') ?? 'learner@example.com';
    _learnedWords = prefs.getInt('learnedWords') ?? 0;
    _favoriteCount = prefs.getInt('favoriteCount') ?? 0;
    _streakDays = prefs.getInt('streakDays') ?? 0;
    _userLevel = prefs.getInt('userLevel') ?? 1;
    _totalMastery = prefs.getDouble('totalMastery') ?? 0.0;

    final lastLoginString = prefs.getString('lastLogin');
    if (lastLoginString != null) {
      _lastLogin = DateTime.parse(lastLoginString);
      _updateStreak();
    }

    notifyListeners();
  }

  // Save user data to shared preferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    await prefs.setString('email', _email);
    await prefs.setInt('learnedWords', _learnedWords);
    await prefs.setInt('favoriteCount', _favoriteCount);
    await prefs.setInt('streakDays', _streakDays);
    await prefs.setInt('userLevel', _userLevel);
    await prefs.setDouble('totalMastery', _totalMastery);
    await prefs.setString('lastLogin', _lastLogin.toIso8601String());
  }

  // Update streak
  void _updateStreak() {
    final now = DateTime.now();
    final difference = now.difference(_lastLogin);

    if (difference.inDays == 1) {
      // Consecutive day
      _streakDays++;
    } else if (difference.inDays > 1) {
      // Streak broken
      _streakDays = 1;
    } else if (_streakDays == 0) {
      // First day
      _streakDays = 1;
    }

    _lastLogin = now;
    _saveUserData();
    notifyListeners();
  }

  // Update methods
  void updateUsername(String newUsername) {
    _username = newUsername;
    _saveUserData();
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    _saveUserData();
    notifyListeners();
  }

  void incrementLearnedWords() {
    _learnedWords++;
    _checkLevelUp();
    _saveUserData();
    notifyListeners();
  }

  void updateFavoriteCount(int count) {
    _favoriteCount = count;
    _saveUserData();
    notifyListeners();
  }

  void updateTotalMastery(double mastery) {
    _totalMastery = mastery;
    _saveUserData();
    notifyListeners();
  }

  void _checkLevelUp() {
    final newLevel = (_learnedWords ~/ 10) + 1;
    if (newLevel > _userLevel) {
      _userLevel = newLevel;
      // You could trigger a level up animation here
    }
  }

  void updateStudyStats({
    bool? correctAnswer,
    bool? quizCompleted,
  }) {
    // You can implement this based on your needs
    // For example:
    if (correctAnswer != null) {
      if (correctAnswer) {
        // Increment correct answers counter
      } else {
        // Increment incorrect answers counter
      }
    }

    if (quizCompleted == true) {
      // Increment quizzes completed counter
    }

    _saveUserData();
    notifyListeners();
  }

  // Reset user data
  Future<void> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

    _username = 'Learner';
    _email = 'learner@example.com';
    _learnedWords = 0;
    _favoriteCount = 0;
    _streakDays = 0;
    _userLevel = 1;
    _totalMastery = 0.0;
    _lastLogin = DateTime.now();

    await _saveUserData();
    notifyListeners();
  }

  // Get user stats for display
  Map<String, dynamic> getUserStats() {
    return {
      'username': _username,
      'level': _userLevel,
      'learnedWords': _learnedWords,
      'favorites': _favoriteCount,
      'streak': _streakDays,
      'mastery': _totalMastery,
    };
  }

  // Export user data (for backup)
  Map<String, dynamic> exportData() {
    return {
      'username': _username,
      'email': _email,
      'learnedWords': _learnedWords,
      'favoriteCount': _favoriteCount,
      'streakDays': _streakDays,
      'userLevel': _userLevel,
      'totalMastery': _totalMastery,
      'lastLogin': _lastLogin.toIso8601String(),
    };
  }

  // Import user data (for restore)
  Future<void> importData(Map<String, dynamic> data) async {
    _username = data['username'] ?? _username;
    _email = data['email'] ?? _email;
    _learnedWords = data['learnedWords'] ?? _learnedWords;
    _favoriteCount = data['favoriteCount'] ?? _favoriteCount;
    _streakDays = data['streakDays'] ?? _streakDays;
    _userLevel = data['userLevel'] ?? _userLevel;
    _totalMastery = data['totalMastery'] ?? _totalMastery;

    final lastLoginString = data['lastLogin'];
    if (lastLoginString != null) {
      _lastLogin = DateTime.parse(lastLoginString);
    }

    await _saveUserData();
    notifyListeners();
  }
}