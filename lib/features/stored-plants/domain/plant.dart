class Plant {
  final String scientificName;

  const Plant({required this.scientificName});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      scientificName: json['scientificName'] ?? '',
    );
  }
}
