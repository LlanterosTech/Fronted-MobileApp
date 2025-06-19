import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantita_app_movil/core/app_constants.dart';
import 'package:plantita_app_movil/features/auth/data/remote/token_service.dart';
import 'package:plantita_app_movil/features/stored-plants/domain/plant.dart';

class IdentificationPlantsService {
  get selectedImage => null;

  Future<Plant?> postIdentificationPlants(File imageFile) async {
    final token = await TokenService.getToken();
    final url =
        Uri.parse(AppConstants.apiBaseUrl + AppConstants.identification);

    var request = http.MultipartRequest('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Plant.fromJson(data);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendFormData(
      String plantId, Map<String, dynamic> formPayload) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${AppConstants.apiBaseUrl}/my-plant/$plantId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print(
            "❌ Error enviando datos del formulario: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (error) {
      print("❌ Error enviando datos del formulario: $error");
      rethrow;
    }
  }
}
