import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_exercise_ids';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<Set<int>> getFavoriteIds() async {
    final values = await _prefs.getStringList(_key) ?? [];

    return values.map(int.parse).toSet();
  }

  Future<void> toggleFavorite(int exerciseId) async {
    final favorites = await getFavoriteIds();

    if (favorites.contains(exerciseId)) {
      favorites.remove(exerciseId);
    } else {
      favorites.add(exerciseId);
    }

    await _prefs.setStringList(
      _key,
      favorites.map((id) => id.toString()).toList(),
    );
  }
}