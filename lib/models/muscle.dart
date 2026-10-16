class Muscle {
  final String name;
  final String img;

  const Muscle({
    required this.name,
    required this.img
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      name: json['name'] ?? 'Nom inconnu',
      img: json['image_url_main'] ?? '',
    );
  }
}