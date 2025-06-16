class SignInDto {
  final String user;
  final String password;

  SignInDto({
    required this.user,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'password': password,
    };
  }

  factory SignInDto.fromJson(Map<String, dynamic> json) {
    return SignInDto(
      user: json['user'] as String,
      password: json['password'] as String,
    );
  }
}
