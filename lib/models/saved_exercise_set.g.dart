// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_exercise_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedExerciseSetAdapter extends TypeAdapter<SavedExerciseSet> {
  @override
  final typeId = 2;

  @override
  SavedExerciseSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedExerciseSet(
      repetitions: (fields[0] as num).toInt(),
      weightKg: (fields[1] as num).toDouble(),
      restSeconds: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedExerciseSet obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.repetitions)
      ..writeByte(1)
      ..write(obj.weightKg)
      ..writeByte(2)
      ..write(obj.restSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedExerciseSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
