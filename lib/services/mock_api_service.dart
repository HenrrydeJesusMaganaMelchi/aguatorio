// lib/services/mock_api_service.dart

import 'package:aguatorio/models/activity.dart';
import 'package:aguatorio/models/achievement.dart';
import 'package:aguatorio/models/daily_summary.dart';
import 'package:aguatorio/models/user.dart';
import 'package:aguatorio/models/water_log.dart';

/* ¡IMPORTANTE!
Si ves un error aquí, reemplaza 'aguatorio' con 
el nombre real de tu proyecto (el nombre de la carpeta).
*/

class MockApiService {
  // --- Inicio: Configuración de Singleton ---
  static final MockApiService _instance = MockApiService._internal();

  factory MockApiService() {
    return _instance;
  }

  MockApiService._internal();
  // --- Fin: Configuración de Singleton ---

  // --- "Memoria" Falsa del Servicio ---
  int _userDailyGoal = 2000; // Meta base por defecto

  // --- INICIO DE LA MODIFICACIÓN ---
  int _currentConsumption = 0; // ¡Consumo inicializado en 0!
  // --- FIN DE LA MODIFICACIÓN ---

  // Simula un retraso de red
  static Future<void> _simulateNetworkDelay() {
    return Future.delayed(const Duration(milliseconds: 800));
  }

  // --- Simulación de Autenticación ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    await _simulateNetworkDelay();

    if (email == "test@test.com") {
      return {
        "token": "fake_token_123456789",
        "user": User.fromJson({
          "id": 1,
          "name": "Usuario de Prueba",
          "email": "test@test.com",
          "profile_image_url": null,
          "phone": "9981234567",
          "address": "Av. Siempre Viva 123",
        }),
      };
    } else {
      throw Exception('Credenciales incorrectas');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    await _simulateNetworkDelay();
    return {
      "token": "fake_token_987654321",
      "user": User.fromJson({
        "id": 2,
        "name": data['name'],
        "email": data['email'],
        "profile_image_url": null,
        "phone": data['phone'],
        "address": data['address'],
      }),
    };
  }

  // --- Simulación de Lógica de Negocio ---

  Future<void> calculateAndSaveGoal(
    double weight,
    String activity,
    String climate,
  ) async {
    await _simulateNetworkDelay();

    int newGoal = (weight * 35).toInt(); // Fórmula base (35ml por kg)

    if (activity == 'moderado') {
      newGoal += 500;
    } else if (activity == 'activo') {
      newGoal += 1000;
    }

    if (climate == 'calido') {
      newGoal += 500;
    }

    _userDailyGoal = newGoal;
    _currentConsumption = 0; // Resetea el consumo al calcular nueva meta
    print("MockService: Nueva meta calculada y guardada: $_userDailyGoal ml");
  }

  // --- Simulación de Datos de la App ---

  Future<List<Activity>> getActivities() async {
    await _simulateNetworkDelay();
    final fakeJson = [
      {"id": 1, "name": "Gimnasio", "icon_url": null},
      {"id": 2, "name": "Correr", "icon_url": null},
      {"id": 3, "name": "Oficina", "icon_url": null},
      {"id": 4, "name": "Descansando", "icon_url": null},
    ];

    return fakeJson.map((json) => Activity.fromJson(json)).toList();
  }

  Future<List<Achievement>> getAchievements() async {
    await _simulateNetworkDelay();
    final fakeJson = [
      {
        "id": 1,
        "title": "Madrugador",
        "description": "Registra tu primer vaso antes de las 8 a.m.",
        "icon_url": null,
        "is_earned": true,
      },
      {
        "id": 2,
        "title": "Consistencia",
        "description": "Registra tu consumo 3 días seguidos.",
        "icon_url": null,
        "is_earned": false,
      },
      {
        "id": 3,
        "title": "¡Bien Hidratado!",
        "description": "Completa tu meta diaria por primera vez.",
        "icon_url": null,
        "is_earned": true,
      },
    ];
    return fakeJson.map((json) => Achievement.fromJson(json)).toList();
  }

  Future<DailySummary> getDailySummary(DateTime date) async {
    await _simulateNetworkDelay();

    final fakeJson = {
      "date": "2025-11-05",
      "total_consumed_ml": _currentConsumption, // <-- USA LA VARIABLE (ahora 0)
      "goal_ml": _userDailyGoal,
      "hourly_breakdown": {
        "08:00": _currentConsumption > 0
            ? _currentConsumption
            : 0, // Simulación simple
      },
    };
    return DailySummary.fromJson(fakeJson);
  }

  Future<WaterLog> postWaterLog(
    int amountMl,
    DateTime timestamp,
    int? activityId,
  ) async {
    await _simulateNetworkDelay();

    // --- LÓGICA DE SUMA ---
    _currentConsumption += amountMl;
    print("MockService: Consumo añadido. Nuevo total: $_currentConsumption");

    final fakeJson = {
      "id": 101,
      "user_id": 1,
      "amount_ml": amountMl,
      "timestamp": timestamp.toIso8601String(),
      "activity_id": activityId,
    };
    return WaterLog.fromJson(fakeJson);
  }
}
