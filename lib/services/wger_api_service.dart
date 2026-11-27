import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import '../models/exercise_model.dart';

class WgerApiService {
  static const baseUrl = 'https://wger.de/api/v2';

  Future<List<ExerciseModel>> fetchExercises() async {
    final uri = Uri.parse('$baseUrl/exerciseinfo/?language__code=12&limit=20');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger les exercices');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    return results.map((json) => ExerciseModel.fromJson(json)).toList();
  }

  Future<List<ExerciseModel>> fetchExercisesFilterName(String name) async {
    final uri = Uri.parse(
      '$baseUrl/exerciseinfo/?language__code=12&limit=20&name__search=$name',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger les exercices');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    return results.map((json) => ExerciseModel.fromJson(json)).toList();
  }
}
