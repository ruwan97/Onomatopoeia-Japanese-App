import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'onomatopoeia_model.g.dart';

@HiveType(typeId: 0)
class Onomatopoeia extends Equatable {
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
  final String imagePath;

  @HiveField(14)
  final List<String> tags;

  @HiveField(15)
  bool isFavorite;

  @HiveField(16)
  int viewCount;

  @HiveField(17)
  final String addedDate;

  @HiveField(18)
  int masteryLevel;

  @HiveField(19)
  int quizAttempts;

  @HiveField(20)
  int correctAnswers;

  @HiveField(21)
  final List<Map<String, dynamic>> relatedMedia;

  @HiveField(22)
  int practiceCount;

  Onomatopoeia({
    required this.id,
    required this.japanese,
    required this.romaji,
    required this.meaning,
    required this.category,
    required this.subCategory,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.soundType,
    required this.usageContext,
    required this.similarWords,
    required this.soundPath,
    required this.difficulty,
    required this.imagePath,
    required this.tags,
    this.isFavorite = false,
    this.viewCount = 0,
    required this.addedDate,
    this.masteryLevel = 0,
    this.quizAttempts = 0,
    this.correctAnswers = 0,
    this.relatedMedia = const [],
    this.practiceCount = 0,
  });

  double get masteryPercentage {
    if (quizAttempts == 0) return 0.0;
    return (correctAnswers / quizAttempts) * 100;
  }

  factory Onomatopoeia.fromJson(Map<String, dynamic> json) {
    return Onomatopoeia(
      id: json['id'],
      japanese: json['japanese'],
      romaji: json['romaji'],
      meaning: json['meaning'],
      category: json['category'],
      subCategory: json['subCategory'],
      exampleSentence: json['exampleSentence'],
      exampleTranslation: json['exampleTranslation'],
      soundType: json['soundType'],
      usageContext: json['usageContext'] ?? '',
      similarWords: List<String>.from(json['similarWords'] ?? []),
      soundPath: json['soundPath'],
      difficulty: json['difficulty'],
      imagePath: json['imagePath'],
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      addedDate: json['addedDate'],
      masteryLevel: json['masteryLevel'] ?? 0,
      quizAttempts: json['quizAttempts'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      relatedMedia: List<Map<String, dynamic>>.from(json['relatedMedia'] ?? []),
      practiceCount: json['practiceCount'] ?? 0,
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
      'imagePath': imagePath,
      'tags': tags,
      'isFavorite': isFavorite,
      'viewCount': viewCount,
      'addedDate': addedDate,
      'masteryLevel': masteryLevel,
      'quizAttempts': quizAttempts,
      'correctAnswers': correctAnswers,
      'relatedMedia': relatedMedia,
      'practiceCount': practiceCount,
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
    String? imagePath,
    List<String>? tags,
    bool? isFavorite,
    int? viewCount,
    String? addedDate,
    int? masteryLevel,
    int? quizAttempts,
    int? correctAnswers,
    List<Map<String, dynamic>>? relatedMedia,
    int? practiceCount,
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
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      viewCount: viewCount ?? this.viewCount,
      addedDate: addedDate ?? this.addedDate,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      quizAttempts: quizAttempts ?? this.quizAttempts,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      relatedMedia: relatedMedia ?? this.relatedMedia,
      practiceCount: practiceCount ?? this.practiceCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isFavorite,
        viewCount,
        masteryLevel,
        practiceCount,
        quizAttempts,
        correctAnswers,
      ];
}
