import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aguatorio/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente');
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
  }

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Prueba Firebase - Ver consola')),
      ),
    ),
  );
}
