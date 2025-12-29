// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onomatopoeia_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnomatopoeiaAdapter extends TypeAdapter<Onomatopoeia> {
  @override
  final int typeId = 0;

  @override
  Onomatopoeia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Onomatopoeia(
      id: fields[0] as String,
      japanese: fields[1] as String,
      romaji: fields[2] as String,
      meaning: fields[3] as String,
      category: fields[4] as String,
      subCategory: fields[5] as String,
      exampleSentence: fields[6] as String,
      exampleTranslation: fields[7] as String,
      soundType: fields[8] as String,
      usageContext: fields[9] as String,
      similarWords: (fields[10] as List).cast<String>(),
      soundPath: fields[11] as String,
      difficulty: fields[12] as int,
      isFavorite: fields[13] as bool,
      viewCount: fields[14] as int,
      practiceCount: fields[15] as int,
      addedDate: fields[16] as DateTime?,
      mastery: fields[17] as double,
      lastPracticed: fields[18] as DateTime?,
      imagePath: fields[19] as String,
      tags: (fields[20] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Onomatopoeia obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.japanese)
      ..writeByte(2)
      ..write(obj.romaji)
      ..writeByte(3)
      ..write(obj.meaning)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.subCategory)
      ..writeByte(6)
      ..write(obj.exampleSentence)
      ..writeByte(7)
      ..write(obj.exampleTranslation)
      ..writeByte(8)
      ..write(obj.soundType)
      ..writeByte(9)
      ..write(obj.usageContext)
      ..writeByte(10)
      ..write(obj.similarWords)
      ..writeByte(11)
      ..write(obj.soundPath)
      ..writeByte(12)
      ..write(obj.difficulty)
      ..writeByte(13)
      ..write(obj.isFavorite)
      ..writeByte(14)
      ..write(obj.viewCount)
      ..writeByte(15)
      ..write(obj.practiceCount)
      ..writeByte(16)
      ..write(obj.addedDate)
      ..writeByte(17)
      ..write(obj.mastery)
      ..writeByte(18)
      ..write(obj.lastPracticed)
      ..writeByte(19)
      ..write(obj.imagePath)
      ..writeByte(20)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnomatopoeiaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
