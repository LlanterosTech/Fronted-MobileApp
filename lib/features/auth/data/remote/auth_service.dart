import 'package:plantita_app_movil/core/app_constants.dart';
import 'package:plantita_app_movil/features/auth/data/remote/sign_in_dto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantita_app_movil/features/auth/data/remote/sign_up_dto.dart';
import 'package:plantita_app_movil/features/auth/data/remote/token_service.dart';

class AuthService {
  Future<SignInDto?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(AppConstants.signIn),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Respuesta: "${response.body}"');
    final json = jsonDecode(response.body);
    print('Status code: ${response.statusCode}');

    if (response.statusCode == HttpStatus.ok) {
      print("Usuario autenticado correctamente");
      final signInDto = SignInDto.fromJson(json);
      await TokenService.saveToken(signInDto.jwtToken);
      print("Token: ${json['jwtToken']}");
      return signInDto;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      print("No esta autenticado");
    }

    if (response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      // ...
    } else {
      print('El body está vacío');
    }

    return null;
  }

  Future<SignUpResponseDto?> signUp(String email, String name, String lastName,
      String password, String preferredLanguage, String role) async {
    final response = await http.post(
      Uri.parse(AppConstants.signUp),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'name': name,
        'lastName': lastName,
        'password': password,
        'preferredLanguage': 'Español',
        'role': 'User',
        'timeZone': DateTime.now().timeZoneName,
        'dateCreated': DateTime.now().toIso8601String(),
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.badRequest) {
      return SignUpResponseDto.fromJson(json);
    }
    return null;
  }
}
