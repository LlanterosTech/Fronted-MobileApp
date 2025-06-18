class UserDto {
  final String id;
  final String email;
  final String name;
  final String timeZone;
  final String preferredLanguage;
  final String role;

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.timeZone,
    required this.preferredLanguage,
    required this.role,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      timeZone: json['timeZone'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      role: json['role'] as String,
    );
  }
}
