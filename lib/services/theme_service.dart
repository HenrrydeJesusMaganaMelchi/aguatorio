// lib/services/theme_service.dart
import 'package:flutter/material.dart';

// 1. Usamos 'ChangeNotifier' para que pueda "notificar"
//    a la app cuando haya un cambio.
class ThemeService with ChangeNotifier {
  // 2. El estado que guardamos: el modo de tema.
  //    'ThemeMode.system' usa el modo del S.O. por defecto.
  ThemeMode _themeMode = ThemeMode.light;

  // 3. Un 'getter' para que la app pueda leer el estado actual.
  ThemeMode get themeMode => _themeMode;

  // 4. La función para cambiar el tema
  void toggleTheme(bool isDark) {
    // Si el interruptor está "encendido" (isDark), usa el modo oscuro.
    // Si no, usa el modo claro.
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    // 5. ¡Notifica a todos los 'oyentes' (la app) que el estado cambió!
    notifyListeners();
  }
}
