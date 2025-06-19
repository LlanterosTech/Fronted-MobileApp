class Plant {
  final String plantId;
  final String scientificName;

  const Plant({required this.plantId, required this.scientificName});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['plantId'] ?? '',
      scientificName: json['scientificName'] ?? '',
    );
  }
}
