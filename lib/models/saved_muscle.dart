import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:muscle_app/models/muscleModel.dart';

part 'saved_muscle.g.dart';

@HiveType(typeId: 0)
class SavedMuscle {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String img;

  const SavedMuscle({required this.name, required this.img});

  factory SavedMuscle.fromApi(MuscleModel muscle) {
    return SavedMuscle(name: muscle.name, img: muscle.img);
  }
}
