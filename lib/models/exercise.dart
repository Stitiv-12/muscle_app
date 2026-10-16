import 'package:muscle_app/models/muscle.dart';

class Exercise {
  final int id;
  final String name;
  final String description;
  final String category;
  final List<Muscle> muscles;
  final List<String> equipment;
  final List<String> images;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.muscles,
    required this.equipment,
    required this.images,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? 0,
      name: _getExerciseName(json),
      description: json['description'] ?? '',
      category: json['category']?['name'] ?? '',
      muscles: (json['muscles'] as List? ?? [])
          .map((muscleJson) => Muscle.fromJson(muscleJson))
          .toList(),
      equipment: (json['equipment'] as List? ?? [])
          .map((item) => item['name'].toString())
          .toList(),
      images: (json['images'] as List? ?? [])
          .map((image) => image['image'].toString())
          .toList(),
    );
  }

  static String _getExerciseName(Map<String, dynamic> json) {
    final translations = json['translations'] as List? ?? [];

    // Français
    for (final translation in translations) {
      if (translation['language'] == 12) {
        return translation['name'] ?? 'Nom inconnu';
      }
    }

    // Premier nom disponible en solution de secours
    if (translations.isNotEmpty) {
      return translations.first['name'] ?? 'Nom inconnu';
    }

    return json['name'] ?? 'Nom inconnu';
  }
}