import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantita_app_movil/core/app_constants.dart';
import 'package:plantita_app_movil/features/stored-plants/domain/plant.dart';

class IdentificationPlantsService {
  get selectedImage => null;

  Future<Plant?> postIdentificationPlants(File imageFile) async {
    final url =
        Uri.parse(AppConstants.apiBaseUrl + AppConstants.identification);

    var request = http.MultipartRequest('POST', url);
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
}
