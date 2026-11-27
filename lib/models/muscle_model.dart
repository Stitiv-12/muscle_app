class MuscleModel {
  final String name;
  final String img;

  const MuscleModel({required this.name, required this.img});

  factory MuscleModel.fromJson(Map<String, dynamic> json) {
    return MuscleModel(
      name: json['name'] ?? 'Nom inconnu',
      img: json['image_url_main'] ?? '',
    );
  }
}
