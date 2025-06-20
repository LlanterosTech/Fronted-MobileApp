import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/data/remote/user_service.dart';
import 'package:plantita_app_movil/features/stored-plants/data/remote/plant_service.dart';
import 'package:plantita_app_movil/features/stored-plants/domain/plant.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:plantita_app_movil/features/stored-plants/presentation/sidebar_widget.dart';

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
  bool isSidebarExpanded = false;

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
        noteController.clear();
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
      backgroundColor: const Color.fromARGB(255, 164, 214, 159),
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 40),
        backgroundColor: const Color.fromARGB(255, 42, 112, 40),
        actions: const [
          Icon(Icons.person, size: 28, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Contenido principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text("¡Hola, $userName!",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text(
                              "Sube una imagen para identificar tu planta"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  selectedImage = File(pickedFile.path);
                                });
                              }
                            },
                            icon: const Icon(Icons.upload, color: Colors.black),
                            label: const Text(
                                "Seleccionar una imagen de tu planta",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 107, 169, 41),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed:
                                selectedImage == null ? null : identifyPlant,
                            icon: const Icon(Icons.search, color: Colors.black),
                            label: const Text("Identificar Planta",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
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
                          color: const Color.fromARGB(255, 227, 243, 215),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text("🌿 Resultado \n",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                if (selectedImage != null)
                                  Image.file(selectedImage!),
                                const Text("\n"),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Nombre científico: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: identifiedPlant!.scientificName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: const Color.fromARGB(255, 229, 242, 212),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Registra tu planta \n",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                      labelText: "Nombre"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: locationController,
                                  decoration: const InputDecoration(
                                      labelText: "Ubicación"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: noteController,
                                  decoration: const InputDecoration(
                                    labelText: "Descripción",
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                                    backgroundColor:
                                        const Color.fromARGB(255, 107, 169, 41),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    "Enviar",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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

          // Sidebar flotante
          if (isSidebarExpanded)
            Positioned(
              top: kToolbarHeight - 55,
              left: 0,
              bottom: 0,
              child: SideBarWidget(
                userName: userName,
                isExpanded: true,
                onToggle: () {
                  setState(() {
                    isSidebarExpanded = false;
                  });
                },
              ),
            ),

          // Botón de menú flotante si el sidebar está cerrado
          if (!isSidebarExpanded)
            Positioned(
              top: kToolbarHeight - 55,
              left: 0,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  setState(() {
                    isSidebarExpanded = true;
                  });
                },
                backgroundColor: const Color.fromARGB(255, 164, 214, 159),
                foregroundColor: Colors.black87,
                child: const Icon(Icons.menu),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          '© Todos los derechos reservados por Plantita',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
