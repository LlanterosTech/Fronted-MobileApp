class SignInDto {
  final String message;

  SignInDto({required this.message});

  factory SignInDto.fromJson(Map<String, dynamic> json) {
    return SignInDto(
      message: json['message'] as String,
    );
  }
}
