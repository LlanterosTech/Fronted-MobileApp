import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantita_app_movil/core/app_constants.dart';
import 'package:plantita_app_movil/features/auth/data/remote/token_service.dart';
import 'package:plantita_app_movil/features/auth/data/remote/user_dto.dart';

class UserService {
  Future<UserDto?> getInfoUser() async {
    try {
      final token = await TokenService.getToken();
      final response = await http.get(
        Uri.parse(AppConstants.userInfo),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return UserDto.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == HttpStatus.unauthorized) {
        print("⚠️ Usuario no autenticado o token expirado.");
        return null;
      } else {
        print("❌ Error obteniendo usuario: ${response.reasonPhrase}");
        throw Exception('Error al obtener usuario');
      }
    } catch (error) {
      print("❌ Error obteniendo usuario: $error");
      rethrow; // Lanza otros errores
    }
  }
}
