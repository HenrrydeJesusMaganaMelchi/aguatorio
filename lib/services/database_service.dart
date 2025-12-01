// lib/services/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a la colección de usuarios
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Crear perfil de usuario en Firestore después del registro
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      await _usersCollection.doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'profileImageUrl': null,
        'weight': null,
        'activityLevel': null,
        'climate': null,
        'dailyWaterGoal': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al crear perfil de usuario: $e');
    }
  }

  /// Guardar datos del cuestionario (onboarding) y calcular meta de agua
  Future<void> saveOnboardingData({
    required String uid,
    required double weight,
    required String activityLevel,
    required String climate,
  }) async {
    try {
      // Calcular la meta diaria de agua
      final dailyGoal = calculateDailyWaterGoal(
        weight: weight,
        activityLevel: activityLevel,
        climate: climate,
      );

      // Actualizar el documento del usuario
      await _usersCollection.doc(uid).update({
        'weight': weight,
        'activityLevel': activityLevel,
        'climate': climate,
        'dailyWaterGoal': dailyGoal,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al guardar datos de onboarding: $e');
    }
  }

  /// Calcular la meta diaria de agua en mililitros
  ///
  /// Fórmula:
  /// - Base: 35 ml por kg de peso
  /// - Ajuste por actividad física:
  ///   * Poco: +0%
  ///   * Moderado: +20%
  ///   * Activo: +40%
  /// - Ajuste por clima:
  ///   * Frío: -10%
  ///   * Templado: +0%
  ///   * Cálido: +20%
  int calculateDailyWaterGoal({
    required double weight,
    required String activityLevel,
    required String climate,
  }) {
    // Base: 35 ml por kg
    double baseAmount = weight * 35;

    // Multiplicador por nivel de actividad
    double activityMultiplier;
    switch (activityLevel.toLowerCase()) {
      case 'poco':
        activityMultiplier = 1.0;
        break;
      case 'moderado':
        activityMultiplier = 1.2;
        break;
      case 'activo':
        activityMultiplier = 1.4;
        break;
      default:
        activityMultiplier = 1.0;
    }

    // Multiplicador por clima
    double climateMultiplier;
    switch (climate.toLowerCase()) {
      case 'frio':
        climateMultiplier = 0.9;
        break;
      case 'templado':
        climateMultiplier = 1.0;
        break;
      case 'calido':
        climateMultiplier = 1.2;
        break;
      default:
        climateMultiplier = 1.0;
    }

    // Cálculo final
    double totalAmount = baseAmount * activityMultiplier * climateMultiplier;

    // Redondear a múltiplo de 100 para que sea más limpio
    return (totalAmount / 100).round() * 100;
  }

  /// Obtener perfil del usuario
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener perfil de usuario: $e');
    }
  }

  /// Actualizar perfil del usuario
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? address,
    String? profileImageUrl,
    double? weight,
    String? activityLevel,
    String? climate,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      if (weight != null) updates['weight'] = weight;
      if (activityLevel != null) updates['activityLevel'] = activityLevel;
      if (climate != null) updates['climate'] = climate;

      // Si se actualizó peso, actividad o clima, recalcular la meta
      if (weight != null || activityLevel != null || climate != null) {
        final currentData = await getUserProfile(uid);
        if (currentData != null) {
          final newGoal = calculateDailyWaterGoal(
            weight: weight ?? currentData['weight'] ?? 70.0,
            activityLevel:
                activityLevel ?? currentData['activityLevel'] ?? 'moderado',
            climate: climate ?? currentData['climate'] ?? 'templado',
          );
          updates['dailyWaterGoal'] = newGoal;
        }
      }

      await _usersCollection.doc(uid).update(updates);
    } catch (e) {
      throw Exception('Error al actualizar perfil de usuario: $e');
    }
  }

  /// Stream para escuchar cambios en el perfil del usuario
  Stream<DocumentSnapshot> userProfileStream(String uid) {
    return _usersCollection.doc(uid).snapshots();
  }
}
