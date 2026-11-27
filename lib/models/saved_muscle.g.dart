// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_muscle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedMuscleAdapter extends TypeAdapter<SavedMuscle> {
  @override
  final typeId = 0;

  @override
  SavedMuscle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedMuscle(name: fields[0] as String, img: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, SavedMuscle obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedMuscleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
