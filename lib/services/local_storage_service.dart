import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _favoritesKey = 'favorites';
  static const String _viewCountsKey = 'view_counts';
  static const String _masteryKey = 'mastery';
  static const String _quizStatsKey = 'quiz_stats';

  Future<void> saveFavorites(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(favoriteIds));
  }

  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      return List<String>.from(json.decode(favoritesJson));
    }
    return [];
  }

  Future<void> saveViewCount(String id, int count) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> viewCounts = await loadAllViewCounts();
    viewCounts[id] = count;
    await prefs.setString(_viewCountsKey, json.encode(viewCounts));
  }

  Future<Map<String, int>> loadAllViewCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? countsJson = prefs.getString(_viewCountsKey);
    if (countsJson != null) {
      final Map<String, dynamic> decoded = json.decode(countsJson);
      return decoded.map((key, value) => MapEntry(key, value as int));
    }
    return {};
  }

  Future<void> saveMasteryLevel(String id, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> mastery = await loadAllMastery();
    mastery[id] = level;
    await prefs.setString(_masteryKey, json.encode(mastery));
  }

  Future<Map<String, int>> loadAllMastery() async {
    final prefs = await SharedPreferences.getInstance();
    final String? masteryJson = prefs.getString(_masteryKey);
    if (masteryJson != null) {
      final Map<String, dynamic> decoded = json.decode(masteryJson);
      return decoded.map((key, value) => MapEntry(key, value as int));
    }
    return {};
  }

  Future<void> saveQuizAttempt(String id, bool correct) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, Map<String, int>> stats = await loadQuizStats();

    if (!stats.containsKey(id)) {
      stats[id] = {'attempts': 0, 'correct': 0};
    }

    stats[id]!['attempts'] = stats[id]!['attempts']! + 1;
    if (correct) {
      stats[id]!['correct'] = stats[id]!['correct']! + 1;
    }

    await prefs.setString(_quizStatsKey, json.encode(stats));
  }

  Future<Map<String, Map<String, int>>> loadQuizStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? statsJson = prefs.getString(_quizStatsKey);
    if (statsJson != null) {
      final Map<String, dynamic> decoded = json.decode(statsJson);
      return decoded.map((key, value) => MapEntry(
            key,
            Map<String, int>.from(value),
          ));
    }
    return {};
  }
}
