class SignUpDto {
  final String user;
  final String name;
  final String lastName;
  final String password;
  final String preferredLanguage;
  final String role;

  SignUpDto({
    required this.user,
    required this.name,
    required this.lastName,
    required this.password,
    this.preferredLanguage = 'Español',
    this.role = 'User',
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'password': password,
      'name': name,
      'lastName': lastName,
      'preferredLanguage': preferredLanguage,
      'role': role,
    };
  }

  factory SignUpDto.fromJson(Map<String, dynamic> json) {
    return SignUpDto(
      user: json['user'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'Español',
      role: json['role'] as String? ?? 'User',
    );
  }
}
