// lib/main.dart
import 'package:flutter/material.dart';
import 'package:aguatorio/screens/splash_screen.dart';
import 'package:aguatorio/services/theme_service.dart';
import 'package:provider/provider.dart';

// --- Tus colores ---
const Color kPrimaryBlue = Color(0xFF0066CC);
const Color kSecondaryTeal = Color(0xFF4DB6AC);

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeService(), child: const MyApp()),
  );
}

// --- 1. DEFINIMOS LAS PALETAS DE COLOR FUERA ---
final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryBlue,
  primary:
      kPrimaryBlue, // Forzamos el primario a ser nuestro azul en MODO CLARO
  secondary: kSecondaryTeal,
  brightness: Brightness.light,
);

final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: kPrimaryBlue, // Le damos la semilla
  // ¡NO FORZAMOS EL PRIMARIO! Dejamos que genere uno claro.
  secondary: kSecondaryTeal,
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Aguatorio',
      debugShowCheckedModeBanner: false,

      // --- 2. TEMA CLARO (Usa la paleta clara) ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme, // Usa la paleta clara
        appBarTheme: AppBarTheme(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          iconTheme: IconThemeData(color: _lightColorScheme.onPrimary),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return _lightColorScheme.primary;
              }
              return Colors.grey[200];
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return _lightColorScheme.onPrimary;
              }
              return Colors.black;
            }),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: _lightColorScheme.primary),
          selectedLabelTextStyle: TextStyle(color: _lightColorScheme.primary),
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
          unselectedLabelTextStyle: TextStyle(color: Colors.grey[600]),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: _lightColorScheme.primary,
          unselectedItemColor: Colors.grey[600],
        ),
      ),

      // --- 3. TEMA OSCURO (Usa la paleta oscura) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme, // Usa la paleta oscura
        // Ahora le decimos que use los colores DE SU PROPIA PALETA
        navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme: IconThemeData(
            color: _darkColorScheme.primary,
          ), // ¡Usará el azul claro!
          selectedLabelTextStyle: TextStyle(color: _darkColorScheme.primary),
          unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
          unselectedLabelTextStyle: TextStyle(color: Colors.grey[400]),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: _darkColorScheme.primary, // ¡Usará el azul claro!
          unselectedItemColor: Colors.grey[400],
        ),
      ),

      // --- EL INTERRUPTOR PRINCIPAL ---
      themeMode: themeService.themeMode,

      home: const SplashScreen(),
    );
  }
}
