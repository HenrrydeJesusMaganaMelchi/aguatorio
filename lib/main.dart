// lib/main.dart

import 'package:flutter/material.dart';
import 'package:rive/rive.dart'; // Importante para inicializar Rive en Web
import 'package:provider/provider.dart';
import 'package:aguatorio/screens/splash_screen.dart';
import 'package:aguatorio/services/theme_service.dart';

// --- COLORES MODERNOS ---
// Azul vibrante para la acción principal
const Color kPrimaryBlue = Color(0xFF2563EB);
// Cian para acentos y gradientes
const Color kSecondaryTeal = Color(0xFF06B6D4);

// --- PALETA CLARA ---
final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryBlue,
  primary: kPrimaryBlue,
  secondary: kSecondaryTeal,
  brightness: Brightness.light,
  surface: const Color(0xFFF8FAFC), // Fondo gris muy claro (Slate 50)
);

// --- PALETA OSCURA ---
final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryBlue,
  secondary: kSecondaryTeal,
  brightness: Brightness.dark,
  surface: const Color(
    0xFF0F172A,
  ), // Azul muy oscuro (Slate 900) - Se ve mejor que negro puro
);

void main() async {
  // 1. Aseguramos que el motor de Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializamos Rive (OBLIGATORIO para Web)
  await RiveFile.initialize();

  runApp(
    ChangeNotifierProvider(create: (_) => ThemeService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Aguatorio',
      debugShowCheckedModeBanner: false,

      // ==============================================
      //               TEMA CLARO
      // ==============================================
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: _lightColorScheme.surface,

        // AppBar limpia
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),

        // Tarjetas modernas
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
        ),

        // Botones redondeados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryBlue,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Navegación Lateral (Web)
        navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: kPrimaryBlue),
          selectedLabelTextStyle: TextStyle(
            color: kPrimaryBlue,
            fontWeight: FontWeight.bold,
          ),
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
          unselectedLabelTextStyle: TextStyle(color: Colors.grey[600]),
          backgroundColor: Colors.white,
        ),

        // Navegación Inferior (Móvil)
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryBlue,
          unselectedItemColor: Colors.grey[500],
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      // ==============================================
      //               TEMA OSCURO
      // ==============================================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: _darkColorScheme.surface,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Tarjetas oscuras pero visibles
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF1E293B), // Slate 800
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkColorScheme.primary, // Azul claro generado
            foregroundColor: Colors.black, // Texto negro para contraste
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Navegación Lateral (Web) - Corregido para visibilidad
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: const Color(0xFF0F172A),
          selectedIconTheme: IconThemeData(color: _darkColorScheme.primary),
          selectedLabelTextStyle: TextStyle(
            color: _darkColorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey[400],
          ), // Gris claro
          unselectedLabelTextStyle: TextStyle(color: Colors.grey[400]),
        ),

        // Navegación Inferior (Móvil) - Corregido para visibilidad
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(
            0xFF1E293B,
          ), // Fondo de barra un poco más claro que el fondo app
          selectedItemColor: _darkColorScheme.primary,
          unselectedItemColor: Colors.grey[400], // Gris claro
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      themeMode: themeService.themeMode,
      home: const SplashScreen(),
    );
  }
}
