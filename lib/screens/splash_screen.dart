// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/screens/login_screen.dart'; // Importa tu LoginScreen
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Espera 2 segundos y luego navega a la pantalla de Login
  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- 1. LOGO ---
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 150, // Ajusta el tamaño
            ),

            const SizedBox(height: 24),

            // --- 2. INDICADOR DE CARGA ---
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
