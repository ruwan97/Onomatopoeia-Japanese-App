// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
