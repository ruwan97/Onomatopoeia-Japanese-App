import 'package:hive/hive.dart';

part 'onomatopoeia_model.g.dart'; // Generated file

@HiveType(typeId: 0)
class Onomatopoeia {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String japanese;

  @HiveField(2)
  final String romaji;

  @HiveField(3)
  final String meaning;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String subCategory;

  @HiveField(6)
  final String exampleSentence;

  @HiveField(7)
  final String exampleTranslation;

  @HiveField(8)
  final String soundType;

  @HiveField(9)
  final String usageContext;

  @HiveField(10)
  final List<String> similarWords;

  @HiveField(11)
  final String soundPath;

  @HiveField(12)
  final int difficulty;

  @HiveField(13)
  bool isFavorite;

  @HiveField(14)
  int viewCount;

  @HiveField(15)
  int practiceCount;

  @HiveField(16)
  DateTime addedDate;

  @HiveField(17)
  double mastery;

  @HiveField(18)
  DateTime? lastPracticed;

  @HiveField(19)
  final String imagePath;

  @HiveField(20)
  final List<String> tags;

  Onomatopoeia({
    required this.id,
    required this.japanese,
    required this.romaji,
    required this.meaning,
    required this.category,
    this.subCategory = '',
    required this.exampleSentence,
    this.exampleTranslation = '',
    this.soundType = 'giongo',
    this.usageContext = '',
    this.similarWords = const [],
    required this.soundPath,
    this.difficulty = 1,
    this.isFavorite = false,
    this.viewCount = 0,
    this.practiceCount = 0,
    DateTime? addedDate,
    this.mastery = 0.0,
    this.lastPracticed,
    this.imagePath = '',
    this.tags = const [],
  }) : addedDate = addedDate ?? DateTime.now();

  factory Onomatopoeia.fromJson(Map<String, dynamic> json) {
    return Onomatopoeia(
      id: json['id'],
      japanese: json['japanese'],
      romaji: json['romaji'],
      meaning: json['meaning'],
      category: json['category'],
      subCategory: json['subCategory'] ?? '',
      exampleSentence: json['exampleSentence'],
      exampleTranslation: json['exampleTranslation'] ?? '',
      soundType: json['soundType'] ?? 'giongo',
      usageContext: json['usageContext'] ?? '',
      similarWords: List<String>.from(json['similarWords'] ?? []),
      soundPath: json['soundPath'],
      difficulty: json['difficulty'] ?? 1,
      isFavorite: json['isFavorite'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      practiceCount: json['practiceCount'] ?? 0,
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'])
          : DateTime.now(),
      mastery: (json['mastery'] ?? 0.0).toDouble(),
      lastPracticed: json['lastPracticed'] != null
          ? DateTime.parse(json['lastPracticed'])
          : null,
      imagePath: json['imagePath'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'japanese': japanese,
      'romaji': romaji,
      'meaning': meaning,
      'category': category,
      'subCategory': subCategory,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'soundType': soundType,
      'usageContext': usageContext,
      'similarWords': similarWords,
      'soundPath': soundPath,
      'difficulty': difficulty,
      'isFavorite': isFavorite,
      'viewCount': viewCount,
      'practiceCount': practiceCount,
      'addedDate': addedDate.toIso8601String(),
      'mastery': mastery,
      'lastPracticed': lastPracticed?.toIso8601String(),
      'imagePath': imagePath,
      'tags': tags,
    };
  }

  Onomatopoeia copyWith({
    String? id,
    String? japanese,
    String? romaji,
    String? meaning,
    String? category,
    String? subCategory,
    String? exampleSentence,
    String? exampleTranslation,
    String? soundType,
    String? usageContext,
    List<String>? similarWords,
    String? soundPath,
    int? difficulty,
    bool? isFavorite,
    int? viewCount,
    int? practiceCount,
    DateTime? addedDate,
    double? mastery,
    DateTime? lastPracticed,
    String? imagePath,
    List<String>? tags,
  }) {
    return Onomatopoeia(
      id: id ?? this.id,
      japanese: japanese ?? this.japanese,
      romaji: romaji ?? this.romaji,
      meaning: meaning ?? this.meaning,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      soundType: soundType ?? this.soundType,
      usageContext: usageContext ?? this.usageContext,
      similarWords: similarWords ?? this.similarWords,
      soundPath: soundPath ?? this.soundPath,
      difficulty: difficulty ?? this.difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
      viewCount: viewCount ?? this.viewCount,
      practiceCount: practiceCount ?? this.practiceCount,
      addedDate: addedDate ?? this.addedDate,
      mastery: mastery ?? this.mastery,
      lastPracticed: lastPracticed ?? this.lastPracticed,
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
    );
  }

  void incrementViewCount() {
    viewCount++;
  }

  void incrementPracticeCount() {
    practiceCount++;
    lastPracticed = DateTime.now();
    mastery = (mastery + 0.1).clamp(0.0, 1.0);
  }

  String get masteryLevel {
    if (mastery < 0.3) return 'Beginner';
    if (mastery < 0.6) return 'Intermediate';
    if (mastery < 0.9) return 'Advanced';
    return 'Master';
  }
}