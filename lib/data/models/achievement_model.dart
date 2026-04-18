import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 2)
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

@HiveType(typeId: 3)
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

  @HiveField(7)
  bool isUnlocked;

  @HiveField(8)
  DateTime? unlockedAt;

  @HiveField(9)
  int currentProgress;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    required this.type,
    required this.requirements,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });
}
