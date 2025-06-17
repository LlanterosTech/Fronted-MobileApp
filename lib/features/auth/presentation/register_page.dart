import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/data/remote/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final roleController = TextEditingController();
  final AuthService _authService = AuthService();

  String language = 'es';
  String alertMessage = '';
  bool showAlert = false;
  bool success = false;

  void displayAlert(String message, {bool success = false}) {
    setState(() {
      alertMessage = message;
      showAlert = true;
      this.success = success;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showAlert = false;
      });

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  void handleRegister() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final lastname = lastnameController.text.trim();
    final password = passwordController.text.trim();
    final role = roleController.text.trim();
    final preferredLanguage = language;

    final result = await _authService.signUp(
      email,
      name,
      lastname,
      password,
      preferredLanguage,
      role,
    );

    if (!mounted) return;

    if (result != null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    displayAlert("Registro exitoso. Redirigiendo...", success: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/fondo.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 25,
                    )
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/logo.png', width: 110),
                      const SizedBox(height: 30),
                      if (showAlert)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color:
                                success ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            alertMessage,
                            style: TextStyle(
                                color: success ? Colors.green : Colors.red),
                          ),
                        ),
                      buildInput(
                        icon: Icons.mail,
                        hint: "usuario@dominio",
                        controller: emailController,
                        // validator: _emailValidator
                      ),
                      buildInput(
                          icon: Icons.person,
                          hint: "Nombre",
                          controller: nameController),
                      buildInput(
                          icon: Icons.person,
                          hint: "Apellido",
                          controller: lastnameController),
                      buildInput(
                          icon: Icons.lock,
                          hint: "Contraseña",
                          controller: passwordController,
                          obscure: true),
                      buildDropdownInput(icon: Icons.language, value: language),
                      buildInputWithButton(
                        icon: Icons.person,
                        hint: "User / Invitado",
                        controller: roleController,
                        buttonLabel: "Invitado",
                        onButtonPressed: () => roleController.text = "Invitado",
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Registrarse",
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("¿Ya tienes cuenta? ",
                                style: TextStyle(color: Colors.black87)),
                            Text("Inicia Sesión",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_right_alt, color: Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDropdownInput({required IconData icon, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none),
              items: const [
                DropdownMenuItem(value: 'es', child: Text("Español")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (newValue) => setState(() => language = newValue!),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputWithButton({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required String buttonLabel,
    required VoidCallback onButtonPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: onButtonPressed,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF74C905),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return "Ingrese un correo válido.";
    }
    return null;
  }
}
