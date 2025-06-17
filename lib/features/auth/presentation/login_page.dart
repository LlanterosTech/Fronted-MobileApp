import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/data/remote/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => __LoginPageStateState();
}

class __LoginPageStateState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool inputError = false;
  String? alertMessage;
  bool isSubmitting = false;
  final AuthService _authService = AuthService();

  void showAlert(String message) {
    setState(() {
      alertMessage = message;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        alertMessage = null;
      });
    });
  }

  void handleLogin() async {
    setState(() => isSubmitting = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showAlert("Complete todo los campos.");
      setState(() => inputError = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => inputError = false);
      setState(() => isSubmitting = false);
      return;
    }

    setState(() => inputError = false);

    final result = await _authService.login(email, password);

    if (!mounted) return;

    setState(() => isSubmitting = false);

    if (result != null) {
      Navigator.pushReplacementNamed(context, '/init');
    } else {
      showAlert("Usuario o contraseña incorrectos.");
      setState(() => inputError = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => inputError = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/fondo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
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
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', width: 110),
                    const SizedBox(height: 30),
                    if (alertMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          alertMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildTextInput(
                      controller: _emailController,
                      icon: Icons.person,
                      hintText: 'Usuario',
                      isError: inputError,
                    ),
                    const SizedBox(height: 16),
                    _buildTextInput(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hintText: 'Contraseña',
                      isError: inputError,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Iniciar Sesión",
                          style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("¿No tienes cuenta? ",
                              style: TextStyle(color: Colors.black87)),
                          Text("Regístrate",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_right_alt, color: Colors.green),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    bool isError = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: isError ? Colors.red : Colors.black, width: 2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
