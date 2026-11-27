// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedExerciseAdapter extends TypeAdapter<SavedExercise> {
  @override
  final typeId = 1;

  @override
  SavedExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedExercise(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      description: fields[2] as String,
      muscles: (fields[3] as List).cast<SavedMuscle>(),
      equipment: (fields[4] as List).cast<String>(),
      images: (fields[5] as List).cast<String>(),
      isFavorite: fields[6] == null ? false : fields[6] as bool,
      listIds: fields[7] == null
          ? const []
          : (fields[7] as List).cast<String>(),
      performedSets: fields[8] == null
          ? const []
          : (fields[8] as List).cast<SavedExerciseSet>(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedExercise obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.muscles)
      ..writeByte(4)
      ..write(obj.equipment)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.listIds)
      ..writeByte(8)
      ..write(obj.performedSets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
