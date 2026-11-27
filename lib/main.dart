import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_app/pages/main_page.dart';
import 'package:muscle_app/providers/settings_providers.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'models/saved_exercise.dart';
import 'models/saved_exercise_set.dart';
import 'models/saved_muscle.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive
    ..registerAdapter(SavedMuscleAdapter())
    ..registerAdapter(SavedExerciseAdapter())
    ..registerAdapter(SavedExerciseSetAdapter());

  await Hive.openBox<SavedExercise>('saved_exercises');
  await Hive.openBox<dynamic>('user_settings');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Muscle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainPage(),
    );
  }
}
