import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? profileImageUrl;

  @HiveField(4)
  final DateTime createdAt;

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
        preferences = preferences ??
            {
              'theme': 'system',
              'notifications': true,
              'sound': true,
              'vibration': true,
              'autoPlay': false,
              'difficulty': 'adaptive',
            },
        achievementIds = achievementIds ?? [],
        categoryProgress = categoryProgress ??
            {
              'Animal': 0,
              'Nature': 0,
              'Human': 0,
              'Object': 0,
              'Food': 0,
              'Vehicle': 0,
              'Music': 0,
              'Technology': 0,
            },
        studyStats = studyStats ??
            {
              'totalStudyTime': 0,
              'dailyAverage': 0,
              'quizzesCompleted': 0,
              'flashcardsReviewed': 0,
              'correctAnswers': 0,
              'incorrectAnswers': 0,
              'accuracy': 0.0,
            };

  // Helper getters
  int get nextLevelExperience => level * 1000;

  int get experienceNeeded => nextLevelExperience - experience;

  double get levelProgress => experience / nextLevelExperience;

  double get totalMastery {
    final totalCategories = categoryProgress.length;
    if (totalCategories == 0) return 0.0;
    final totalProgress =
        categoryProgress.values.fold(0, (sum, progress) => sum + progress);
    return (totalProgress / (totalCategories * 100)).clamp(0.0, 1.0);
  }

  // Methods
  void addExperience(int amount) {
    experience += amount;
    while (experience >= nextLevelExperience) {
      level++;
      experience -= nextLevelExperience;
    }
  }

  void incrementWordsLearned() {
    totalWordsLearned++;
    addExperience(10);
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

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
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
      createdAt: createdAt,
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
}
