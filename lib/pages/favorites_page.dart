import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muscle_app/models/saved_exercise.dart';
import 'package:muscle_app/providers/favorite_providers.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesProvider);
    final exercises = ref.watch(favoriteServiceProvider).getFavoriteExercises();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: exercises.isEmpty
          ? const Center(child: Text('Aucun exercice ajouté aux favoris.'))
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return FavoriteExerciseCard(exercise: exercises[index]);
              },
            ),
    );
  }
}

class FavoriteExerciseCard extends ConsumerWidget {
  const FavoriteExerciseCard({super.key, required this.exercise});

  final SavedExercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Retirer des favoris',
                  onPressed: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .removeFavorite(exercise.id);
                  },
                  icon: const Icon(Icons.favorite, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Muscles concernés',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.muscles.map((muscle) {
                return Chip(
                  avatar: ClipOval(
                    child: muscle.img.isEmpty
                        ? const Icon(Icons.fitness_center)
                        : SvgPicture.network(
                            muscle.img,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            placeholderBuilder: (context) {
                              return const SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 24);
                            },
                          ),
                  ),
                  label: Text(muscle.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              'Matériel nécessaire',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            if (exercise.equipment.isEmpty)
              const Text('Aucun matériel')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: exercise.equipment.map((equipment) {
                  return Chip(
                    avatar: const Icon(Icons.sports_gymnastics, size: 16),
                    label: Text(equipment),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
