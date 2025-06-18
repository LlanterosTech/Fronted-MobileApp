class SignInDto {
  final String message;
  final String jwtToken;
  final String userId;

  SignInDto({
    required this.message,
    required this.jwtToken,
    required this.userId,
  });

  factory SignInDto.fromJson(Map<String, dynamic> json) {
    return SignInDto(
      message: json['message'] as String,
      jwtToken: json['jwtToken'] as String,
      userId: json['userId'] as String,
    );
  }
}
