import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/exercise.dart';
import '../services/wger_api_service.dart';

final wgerApiServiceProvider = Provider<WgerApiService>((ref) {
  return WgerApiService();
});

final exerciseSearchProvider = StateProvider<String>((ref) => '');

final exercisesProvider =
    FutureProvider.autoDispose.family<List<Exercise>, String>((ref, search) {
  final service = ref.watch(wgerApiServiceProvider);

  if (search.trim().isEmpty) {
    return service.fetchExercises();
  }

  return service.fetchExercisesFilterName(search.trim());
});

