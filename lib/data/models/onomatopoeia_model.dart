class Onomatopoeia {
  final String id;
  final String japanese;
  final String romaji;
  final String meaning;
  final String category;
  final String subCategory;
  final String exampleSentence;
  final String exampleTranslation;
  final String soundType;
  final String usageContext;
  final List<String> similarWords;
  final String soundPath;
  final int difficulty;
  final bool isFavorite;
  final int viewCount;
  final DateTime addedDate;
  final double mastery;

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
    DateTime? addedDate,
    this.mastery = 0.0,
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
      addedDate: json['addedDate'] != null
          ? DateTime.parse(json['addedDate'])
          : DateTime.now(),
      mastery: (json['mastery'] ?? 0.0).toDouble(),
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
      'addedDate': addedDate.toIso8601String(),
      'mastery': mastery,
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
    DateTime? addedDate,
    double? mastery,
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
      addedDate: addedDate ?? this.addedDate,
      mastery: mastery ?? this.mastery,
    );
  }
}