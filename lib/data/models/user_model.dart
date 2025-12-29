import 'dart:math';

import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? profileImageUrl;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime lastLogin;

  @HiveField(6)
  int level;

  @HiveField(7)
  int experience;

  @HiveField(8)
  int totalWordsLearned;

  @HiveField(9)
  int totalFavorites;

  @HiveField(10)
  int streakDays;

  @HiveField(11)
  DateTime lastStudyDate;

  @HiveField(12)
  Map<String, dynamic> preferences;

  @HiveField(13)
  List<String> achievementIds;

  @HiveField(14)
  Map<String, int> categoryProgress;

  @HiveField(15)
  Map<String, dynamic> studyStats;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    this.level = 1,
    this.experience = 0,
    this.totalWordsLearned = 0,
    this.totalFavorites = 0,
    this.streakDays = 0,
    DateTime? lastStudyDate,
    Map<String, dynamic>? preferences,
    List<String>? achievementIds,
    Map<String, int>? categoryProgress,
    Map<String, dynamic>? studyStats,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now(),
        lastStudyDate = lastStudyDate ?? DateTime.now(),
        preferences = preferences ?? {
          'theme': 'system',
          'notifications': true,
          'sound': true,
          'vibration': true,
          'autoPlay': false,
          'difficulty': 'adaptive',
        },
        achievementIds = achievementIds ?? [],
        categoryProgress = categoryProgress ?? {
          'Animal': 0,
          'Nature': 0,
          'Human': 0,
          'Object': 0,
          'Food': 0,
          'Vehicle': 0,
          'Music': 0,
          'Technology': 0,
        },
        studyStats = studyStats ?? {
          'totalStudyTime': 0,
          'dailyAverage': 0,
          'quizzesCompleted': 0,
          'flashcardsReviewed': 0,
          'correctAnswers': 0,
          'incorrectAnswers': 0,
          'accuracy': 0.0,
        };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      level: json['level'],
      experience: json['experience'],
      totalWordsLearned: json['totalWordsLearned'],
      totalFavorites: json['totalFavorites'],
      streakDays: json['streakDays'],
      lastStudyDate: DateTime.parse(json['lastStudyDate']),
      preferences: Map<String, dynamic>.from(json['preferences']),
      achievementIds: List<String>.from(json['achievementIds']),
      categoryProgress: Map<String, int>.from(json['categoryProgress']),
      studyStats: Map<String, dynamic>.from(json['studyStats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'level': level,
      'experience': experience,
      'totalWordsLearned': totalWordsLearned,
      'totalFavorites': totalFavorites,
      'streakDays': streakDays,
      'lastStudyDate': lastStudyDate.toIso8601String(),
      'preferences': preferences,
      'achievementIds': achievementIds,
      'categoryProgress': categoryProgress,
      'studyStats': studyStats,
    };
  }

  // Getters
  int get nextLevelExperience => level * 1000;
  int get experienceNeeded => nextLevelExperience - experience;
  double get levelProgress => experience / nextLevelExperience;
  double get totalMastery {
    final totalCategories = categoryProgress.length;
    if (totalCategories == 0) return 0.0;

    final totalProgress = categoryProgress.values.fold(0, (sum, progress) => sum + progress);
    return (totalProgress / (totalCategories * 100)).clamp(0.0, 1.0);
  }

  String get masteryPercentage => '${(totalMastery * 100).toStringAsFixed(1)}%';

  bool get isStreakActive {
    final now = DateTime.now();
    final difference = now.difference(lastStudyDate);
    return difference.inDays <= 1;
  }

  // Methods
  void addExperience(int amount) {
    experience += amount;

    // Check for level up
    while (experience >= nextLevelExperience) {
      level++;
      experience -= nextLevelExperience;
    }
  }

  void incrementWordsLearned() {
    totalWordsLearned++;
    addExperience(10);
  }

  void addFavorite() {
    totalFavorites++;
    addExperience(5);
  }

  void updateCategoryProgress(String category, int progress) {
    categoryProgress[category] = (categoryProgress[category] ?? 0) + progress;
    if (categoryProgress[category]! > 100) {
      categoryProgress[category] = 100;
    }
  }

  void updateStudyStats({
    int? studyTime,
    bool? quizCompleted,
    bool? flashcardReviewed,
    bool? correctAnswer,
  }) {
    if (studyTime != null) {
      final stats = studyStats;
      stats['totalStudyTime'] = (stats['totalStudyTime'] as int) + studyTime;
      stats['dailyAverage'] = (stats['totalStudyTime'] as int) ~/ max(streakDays, 1);
    }

    if (quizCompleted == true) {
      studyStats['quizzesCompleted'] = (studyStats['quizzesCompleted'] as int) + 1;
    }

    if (flashcardReviewed == true) {
      studyStats['flashcardsReviewed'] = (studyStats['flashcardsReviewed'] as int) + 1;
    }

    if (correctAnswer != null) {
      if (correctAnswer) {
        studyStats['correctAnswers'] = (studyStats['correctAnswers'] as int) + 1;
      } else {
        studyStats['incorrectAnswers'] = (studyStats['incorrectAnswers'] as int) + 1;
      }

      final total = (studyStats['correctAnswers'] as int) + (studyStats['incorrectAnswers'] as int);
      if (total > 0) {
        studyStats['accuracy'] = (studyStats['correctAnswers'] as int) / total;
      }
    }
  }

  void updateStreak() {
    final now = DateTime.now();
    final difference = now.difference(lastStudyDate);

    if (difference.inDays == 1) {
      streakDays++;
    } else if (difference.inDays > 1) {
      streakDays = 1;
    } else if (streakDays == 0) {
      streakDays = 1;
    }

    lastStudyDate = now;
  }

  void addAchievement(String achievementId) {
    if (!achievementIds.contains(achievementId)) {
      achievementIds.add(achievementId);
      addExperience(50);
    }
  }

  bool hasAchievement(String achievementId) {
    return achievementIds.contains(achievementId);
  }

  void updatePreference(String key, dynamic value) {
    preferences[key] = value;
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? level,
    int? experience,
    int? totalWordsLearned,
    int? totalFavorites,
    int? streakDays,
    DateTime? lastStudyDate,
    Map<String, dynamic>? preferences,
    List<String>? achievementIds,
    Map<String, int>? categoryProgress,
    Map<String, dynamic>? studyStats,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      preferences: preferences ?? Map.from(this.preferences),
      achievementIds: achievementIds ?? List.from(this.achievementIds),
      categoryProgress: categoryProgress ?? Map.from(this.categoryProgress),
      studyStats: studyStats ?? Map.from(this.studyStats),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, level: $level, experience: $experience/$nextLevelExperience)';
  }
}

// Achievement Model
@HiveType(typeId: 2)
class Achievement {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int points;

  @HiveField(5)
  final AchievementType type;

  @HiveField(6)
  final Map<String, dynamic> requirements;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    required this.type,
    required this.requirements,
  });
}

@HiveType(typeId: 3)
enum AchievementType {
  @HiveField(0)
  streak,

  @HiveField(1)
  learning,

  @HiveField(2)
  mastery,

  @HiveField(3)
  collection,

  @HiveField(4)
  special,
}