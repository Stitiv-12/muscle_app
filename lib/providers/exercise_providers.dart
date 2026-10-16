import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../services/wger_api_service.dart';

final wgerApiServiceProvider = Provider<WgerApiService>((ref) {
  return WgerApiService();
});

final exercisesProvider =
    FutureProvider<List<Exercise>>((ref) async {
  final service = ref.watch(wgerApiServiceProvider);
  return service.fetchExercises();
});