// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream de cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Login con email y contraseña
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No existe una cuenta con este correo electrónico.');
        case 'wrong-password':
          throw Exception('Contraseña incorrecta.');
        case 'invalid-email':
          throw Exception('El formato del correo electrónico es inválido.');
        case 'user-disabled':
          throw Exception('Esta cuenta ha sido deshabilitada.');
        case 'too-many-requests':
          throw Exception('Demasiados intentos fallidos. Intenta más tarde.');
        case 'invalid-credential':
          throw Exception('Las credenciales proporcionadas son incorrectas.');
        default:
          throw Exception('Error de autenticación: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Registro con email y contraseña
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Ya existe una cuenta con este correo electrónico.');
        case 'invalid-email':
          throw Exception('El formato del correo electrónico es inválido.');
        case 'operation-not-allowed':
          throw Exception(
            'El registro con email/contraseña no está habilitado.',
          );
        case 'weak-password':
          throw Exception(
            'La contraseña es muy débil. Debe tener al menos 6 caracteres.',
          );
        default:
          throw Exception('Error al crear cuenta: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Enviar email de recuperación de contraseña
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No existe una cuenta con este correo electrónico.');
        case 'invalid-email':
          throw Exception('El formato del correo electrónico es inválido.');
        default:
          throw Exception('Error al enviar email: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Actualizar nombre de usuario
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
    } catch (e) {
      throw Exception('Error al actualizar nombre: $e');
    }
  }
}
