import 'package:hive_ce_flutter/hive_flutter.dart';

part 'saved_exercise_set.g.dart';

@HiveType(typeId: 2)
class SavedExerciseSet {
  @HiveField(0)
  final int repetitions;

  @HiveField(1)
  final double weightKg;

  @HiveField(2)
  final int restSeconds;

  const SavedExerciseSet({
    required this.repetitions,
    required this.weightKg,
    required this.restSeconds,
  });
}
