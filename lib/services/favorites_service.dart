import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:muscle_app/models/exercise_model.dart';
import 'package:muscle_app/models/saved_exercise.dart';

class FavoritesService {
  static const String _boxName = 'saved_exercises';

  Box<SavedExercise> get _box {
    return Hive.box<SavedExercise>(_boxName);
  }

  Future<Set<int>> getFavoriteIds() async {
    return _box.values
        .where((exercise) => exercise.isFavorite)
        .map((exercise) => exercise.id)
        .toSet();
  }

  /// Retourne les exercices actuellement marqués comme favoris.
  List<SavedExercise> getFavoriteExercises() {
    return _box.values.where((exercise) => exercise.isFavorite).toList();
  }

  /// Retire un exercice des favoris tout en conservant ses données locales.
  Future<void> removeFavorite(int exerciseId) async {
    final savedExercise = _box.get(exerciseId);

    if (savedExercise == null) {
      return;
    }

    await _box.put(exerciseId, savedExercise.copyWith(isFavorite: false));
  }

  /// Ajoute ou retire un exercice des favoris dans Hive.
  Future<void> toggleFavorite(ExerciseModel exercise) async {
    final savedExercise = _box.get(exercise.id);

    if (savedExercise == null) {
      final newSavedExercise = SavedExercise.fromApi(
        exercise,
      ).copyWith(isFavorite: true);

      await _box.put(exercise.id, newSavedExercise);
      return;
    }

    await _box.put(
      exercise.id,
      savedExercise.copyWith(isFavorite: !savedExercise.isFavorite),
    );
  }
}
