import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:muscle_app/models/exercise_model.dart';

import 'saved_exercise_set.dart';
import 'saved_muscle.dart';

part 'saved_exercise.g.dart';

@HiveType(typeId: 1)
class SavedExercise {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<SavedMuscle> muscles;

  @HiveField(4)
  final List<String> equipment;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final bool isFavorite;

  @HiveField(7)
  final List<String> listIds;

  @HiveField(8)
  final List<SavedExerciseSet> performedSets;

  const SavedExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscles,
    required this.equipment,
    required this.images,
    this.isFavorite = false,
    this.listIds = const [],
    this.performedSets = const [],
  });

  /// Convertit un exercice reçu de l'API en modèle local.
  factory SavedExercise.fromApi(ExerciseModel exercise) {
    return SavedExercise(
      id: exercise.id,
      name: exercise.name,
      description: exercise.description,
      muscles: exercise.muscles
          .map((muscle) => SavedMuscle.fromApi(muscle))
          .toList(),
      equipment: exercise.equipment,
      images: exercise.images,
    );
  }

  /// Crée une copie en conservant les données locales non modifiées.
  SavedExercise copyWith({
    bool? isFavorite,
    List<String>? listIds,
    List<SavedExerciseSet>? performedSets,
  }) {
    return SavedExercise(
      id: id,
      name: name,
      description: description,
      muscles: muscles,
      equipment: equipment,
      images: images,
      isFavorite: isFavorite ?? this.isFavorite,
      listIds: listIds ?? this.listIds,
      performedSets: performedSets ?? this.performedSets,
    );
  }
}
