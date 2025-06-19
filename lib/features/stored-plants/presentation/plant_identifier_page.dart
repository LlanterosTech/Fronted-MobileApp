import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/data/remote/user_service.dart';
import 'package:plantita_app_movil/features/stored-plants/data/remote/plant_service.dart';
import 'package:plantita_app_movil/features/stored-plants/domain/plant.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PlantIdentifierPage extends StatefulWidget {
  const PlantIdentifierPage({super.key});

  @override
  PlantIdentifierPageState createState() => PlantIdentifierPageState();
}

class PlantIdentifierPageState extends State<PlantIdentifierPage> {
  String userName = '';
  File? selectedImage;
  Plant? identifiedPlant;
  String plantId = '';
  Map<String, dynamic>? formData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = await UserService().getInfoUser();
    setState(() {
      userName = user?.name ?? "Usuario";
    });
  }

  Future<void> identifyPlant() async {
    if (selectedImage == null) return;
    final plant = await IdentificationPlantsService()
        .postIdentificationPlants(selectedImage!);
    setState(() {
      identifiedPlant = plant;
    });
  }

  Future<void> submitForm() async {
    try {
      final payload = {
        'customName': formData?['customName'] ?? '',
        'location': formData?['location'] ?? '',
        'note': formData?['note'] ?? '',
      };
      plantId = identifiedPlant?.plantId ?? '';

      await IdentificationPlantsService().sendFormData(plantId, payload);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos enviados con éxito!')),
      );

      // Limpiar formulario
      setState(() {
        formData?['customName'] = '';
        formData?['location'] = '';
        formData?['note'] = '';
        nameController.clear();
        locationController.clear();
      });
    } catch (error) {
      print("Error enviando datos del formulario: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error enviando datos. Intenta nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text("Plantita"),
        backgroundColor: const Color(0xFF028090),
        actions: const [
          Icon(Icons.person, size: 28),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("¡Hola, $userName!",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text("Sube una imagen para identificar tu planta"),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              selectedImage = File(pickedFile.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text("Seleccionar imagen"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: selectedImage == null ? null : identifyPlant,
                        icon: const Icon(Icons.search),
                        label: const Text("Identificar Planta"),
                      )
                    ],
                  ),
                ),
              ),
              if (identifiedPlant != null)
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text("🌿 Resultado",
                                style: TextStyle(fontSize: 20)),
                            if (selectedImage != null)
                              Image.file(selectedImage!),
                            Text(
                                "Nombre científico: ${identifiedPlant!.scientificName}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("📋 Registra tu planta",
                                style: TextStyle(fontSize: 18)),
                            TextField(
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: "Nombre"),
                            ),
                            TextField(
                              controller: locationController,
                              decoration:
                                  const InputDecoration(labelText: "Ubicación"),
                            ),
                            TextField(
                              controller: noteController,
                              decoration: const InputDecoration(
                                  labelText: "Descripción"),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  formData = {
                                    'customName': nameController.text,
                                    'location': locationController.text,
                                    'note': noteController.text,
                                  };
                                });
                                submitForm();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const StadiumBorder()),
                              child: const Text("Registrar"),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          '© Todos los derechos reservados por Plantita',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
        ),
      ),
    );
  }
}
