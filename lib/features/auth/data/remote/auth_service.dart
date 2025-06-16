import 'package:plantita_app_movil/core/app_constants.dart';
import 'package:plantita_app_movil/features/auth/data/remote/sign_in_dto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantita_app_movil/features/auth/data/remote/sign_up_dto.dart';

class AuthService {
  Future<SignInDto?> login(String user, String password) async {
    http.Response response = await http.post(Uri.parse(AppConstants.signIn),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(SignInDto(user: user, password: password).toMap()));
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> json = jsonDecode(response.body);
      final loginDto = SignInDto.fromJson(json);
      return loginDto;
    }
    return null;
  }

  Future<bool> signUp(
      String user, String name, String lastName, String password) async {
    http.Response response = await http.post(Uri.parse(AppConstants.signUp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(SignUpDto(
                user: user,
                name: name,
                lastName: lastName,
                password: password,
                preferredLanguage: 'Español',
                role: 'User')
            .toMap()));
    return response.statusCode == HttpStatus.created;
  }
}
