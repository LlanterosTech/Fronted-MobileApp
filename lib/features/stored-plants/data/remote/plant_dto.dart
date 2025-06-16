class PlantDto {
  final String id;
  final String name;
  final String imageUrl;

  const PlantDto({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory PlantDto.fromJson(Map<String, dynamic> json) {
    return PlantDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
