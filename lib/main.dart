import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/presentation/login_page.dart';
import 'dart:ui' as ui;

void main() {
  ui.debugDisableShaderWarmUp = true;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      title: 'Plantita App',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
    );
  }
}
