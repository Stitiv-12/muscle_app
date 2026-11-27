import 'package:flutter_riverpod/legacy.dart';
import 'package:muscle_app/models/exercise_model.dart';
import 'package:muscle_app/services/favorites_service.dart';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  final FavoritesService service;

  FavoritesNotifier(this.service) : super({});

  /// Charge les favoris enregistrés au démarrage.
  Future<void> loadFavorites() async {
    state = await service.getFavoriteIds();
  }

  Future<void> toggleFavorite(ExerciseModel exercise) async {
    await service.toggleFavorite(exercise);

    state = await service.getFavoriteIds();
  }
}
