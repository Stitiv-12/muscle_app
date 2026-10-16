import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import '../models/exercise.dart';

class WgerApiService {
  static const baseUrl = 'https://wger.de/api/v2';

  Future<List<Exercise>> fetchExercises() async {
    final uri = Uri.parse('$baseUrl/exerciseinfo/?language=12&limit=20');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger les exercices');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    return results.map((json) => Exercise.fromJson(json)).toList();
  }
}
