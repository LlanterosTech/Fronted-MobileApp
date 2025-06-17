import 'package:flutter/material.dart';
import 'package:plantita_app_movil/features/auth/presentation/login_page.dart';
import 'package:plantita_app_movil/features/auth/presentation/register_page.dart';
import 'package:plantita_app_movil/features/stored-plants/presentation/plant_identifier_page.dart';

void main() {
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
        routes: {
          '/init': (context) => const PlantIdentifierPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage()
        });
  }
}
