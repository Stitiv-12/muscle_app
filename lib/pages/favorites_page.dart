import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muscle_app/models/saved_exercise.dart';
import 'package:muscle_app/models/saved_exercise_set.dart';
import 'package:muscle_app/providers/favorite_providers.dart';
import 'package:muscle_app/providers/settings_providers.dart';

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
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => WorkoutSetsSheet(exerciseId: exercise.id),
          );
        },
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
              Text('${exercise.performedSets.length} série(s) enregistrée(s)'),
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
      ),
    );
  }
}

class WorkoutSetsSheet extends ConsumerStatefulWidget {
  const WorkoutSetsSheet({super.key, required this.exerciseId});

  final int exerciseId;

  @override
  ConsumerState<WorkoutSetsSheet> createState() => _WorkoutSetsSheetState();
}

class _WorkoutSetsSheetState extends ConsumerState<WorkoutSetsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _repetitionsController = TextEditingController();
  final _weightController = TextEditingController();
  final _restController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restController.text = ref.read(settingsProvider).restSeconds.toString();
  }
  static final _weightInputFormatter = TextInputFormatter.withFunction((
    oldValue,
    newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final normalizedWeight = newValue.text.replaceAll(',', '.');
    final decimalSeparator = normalizedWeight.indexOf('.');
    final decimalCount = decimalSeparator == -1
        ? 0
        : normalizedWeight.length - decimalSeparator - 1;
    final hasSingleSeparator =
        decimalSeparator == normalizedWeight.lastIndexOf('.');

    if (hasSingleSeparator &&
        decimalCount <= 2 &&
        (normalizedWeight == '.' ||
            double.tryParse(normalizedWeight) != null)) {
      return newValue;
    }

    return oldValue;
  });

  @override
  void dispose() {
    _repetitionsController.dispose();
    _weightController.dispose();
    _restController.dispose();
    super.dispose();
  }

  /// Valide puis enregistre la série renseignée dans Hive.
  Future<void> _saveSet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = ref.read(settingsProvider);
    final enteredWeight = double.parse(
      _weightController.text.replaceAll(',', '.'),
    );
    final weight = settings.weightUnit == 'lb'
        ? enteredWeight / 2.2046226218
        : enteredWeight;
    final performedSet = SavedExerciseSet(
      repetitions: int.parse(_repetitionsController.text),
      weightKg: weight,
      restSeconds: int.parse(_restController.text),
    );

    await ref
        .read(favoritesProvider.notifier)
        .addPerformedSet(widget.exerciseId, performedSet);

    _repetitionsController.clear();
    _weightController.clear();
    _restController.text = settings.restSeconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(favoritesProvider);
    final exercise = ref
        .watch(favoriteServiceProvider)
        .getExercise(widget.exerciseId);
    final settings = ref.watch(settingsProvider);

    if (exercise == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Séries effectuées',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (exercise.performedSets.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Aucune série enregistrée.'),
                )
              else
                ...exercise.performedSets.indexed.map((entry) {
                  final index = entry.$1 + 1;
                  final set = entry.$2;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Série $index : ${set.repetitions} répétitions',
                    ),
                    subtitle: Text(
                      '${_formatWeight(set.weightKg, settings.weightUnit)} · repos ${set.restSeconds} s',
                    ),
                  );
                }),
              const Divider(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _repetitionsController,
                      decoration: const InputDecoration(
                        labelText: 'Répétitions',
                        hintText: 'Ex. 12',
                        prefixIcon: Icon(Icons.repeat),
                        suffixText: 'reps',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _positiveIntegerValidator,
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Poids (${settings.weightUnit})',
                        hintText: 'Ex. 42,5',
                        prefixIcon: Icon(Icons.fitness_center),
                        suffixText: 'kg',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [_weightInputFormatter],
                      validator: _nonNegativeWeightValidator,
                    ),
                    TextFormField(
                      controller: _restController,
                      decoration: const InputDecoration(
                        labelText: 'Repos (secondes)',
                        hintText: 'Ex. 90',
                        prefixIcon: Icon(Icons.timer_outlined),
                        suffixText: 's',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _nonNegativeIntegerValidator,
                      onFieldSubmitted: (_) => _saveSet(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _saveSet,
                      icon: const Icon(Icons.add),
                      label: const Text('Enregistrer la série'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Vérifie que le nombre de répétitions est un entier supérieur à zéro.
  String? _positiveIntegerValidator(String? value) {
    final number = int.tryParse(value ?? '');
    if (number == null || number <= 0) {
      return 'Indique un nombre supérieur à 0.';
    }
    return null;
  }

  /// Vérifie que le temps de repos est une durée entière valide.
  String? _nonNegativeIntegerValidator(String? value) {
    final number = int.tryParse(value ?? '');
    if (number == null || number < 0) {
      return 'Indique un nombre positif ou nul.';
    }
    return null;
  }

  /// Vérifie que le poids est une valeur numérique positive ou nulle.
  String? _nonNegativeWeightValidator(String? value) {
    final number = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (number == null || number < 0) {
      return 'Indique un poids positif ou nul.';
    }
    return null;
  }

  /// Formate un poids stocké en kilogrammes dans l'unité choisie par l'utilisateur.
  String _formatWeight(double weightKg, String unit) {
    final value = unit == 'lb' ? weightKg * 2.2046226218 : weightKg;
    return '${value.toStringAsFixed(1)} $unit';
  }
}
