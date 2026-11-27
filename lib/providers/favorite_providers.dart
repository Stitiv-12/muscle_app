import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:muscle_app/notifier/favorites_notifier.dart';
import 'package:muscle_app/services/favorites_service.dart';

final favoriteServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((
  ref,
) {
  final service = ref.watch(favoriteServiceProvider);
  return FavoritesNotifier(service)..loadFavorites();
});
