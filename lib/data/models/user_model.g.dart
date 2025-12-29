part of 'user_model.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      profileImageUrl: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      lastLogin: fields[5] as DateTime?,
      level: fields[6] as int,
      experience: fields[7] as int,
      totalWordsLearned: fields[8] as int,
      totalFavorites: fields[9] as int,
      streakDays: fields[10] as int,
      lastStudyDate: fields[11] as DateTime?,
      preferences: (fields[12] as Map?)?.cast<String, dynamic>(),
      achievementIds: (fields[13] as List?)?.cast<String>(),
      categoryProgress: (fields[14] as Map?)?.cast<String, int>(),
      studyStats: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.profileImageUrl)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastLogin)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.experience)
      ..writeByte(8)
      ..write(obj.totalWordsLearned)
      ..writeByte(9)
      ..write(obj.totalFavorites)
      ..writeByte(10)
      ..write(obj.streakDays)
      ..writeByte(11)
      ..write(obj.lastStudyDate)
      ..writeByte(12)
      ..write(obj.preferences)
      ..writeByte(13)
      ..write(obj.achievementIds)
      ..writeByte(14)
      ..write(obj.categoryProgress)
      ..writeByte(15)
      ..write(obj.studyStats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 2;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      points: fields[4] as int,
      type: fields[5] as AchievementType,
      requirements: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.requirements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementTypeAdapter extends TypeAdapter<AchievementType> {
  @override
  final int typeId = 3;

  @override
  AchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementType.streak;
      case 1:
        return AchievementType.learning;
      case 2:
        return AchievementType.mastery;
      case 3:
        return AchievementType.collection;
      case 4:
        return AchievementType.special;
      default:
        return AchievementType.streak;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementType obj) {
    switch (obj) {
      case AchievementType.streak:
        writer.writeByte(0);
        break;
      case AchievementType.learning:
        writer.writeByte(1);
        break;
      case AchievementType.mastery:
        writer.writeByte(2);
        break;
      case AchievementType.collection:
        writer.writeByte(3);
        break;
      case AchievementType.special:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
