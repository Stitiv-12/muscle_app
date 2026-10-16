import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muscle_app/models/exercise.dart';
import 'package:muscle_app/models/muscle.dart';
import 'package:muscle_app/providers/exercise_providers.dart';

class ExercisesPage extends ConsumerWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(exercisesProvider);
            },
          ),
        ],
      ),
      body: exercisesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Erreur : $error'),
        ),
        data: (exercises) {
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];

              return ExerciseCard(exercise: exercise);
            },
          );
        },
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  void _showMuscleImage(
    BuildContext context,
    Muscle muscle,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  muscle.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                InteractiveViewer(
                  child: Image.network(
                    muscle.img,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            placeholderBuilder: (context) {
                              return const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                            debugPrint('Erreur SVG : $error');
                            debugPrintStack(stackTrace: stackTrace);

                            return const Icon(
                              Icons.broken_image,
                              size: 24,
                            );
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
                    avatar: const Icon(
                      Icons.sports_gymnastics,
                      size: 16,
                    ),
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