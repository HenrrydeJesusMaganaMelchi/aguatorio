// lib/screens/help_support_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // Texto de relleno para las respuestas
  final String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

  // Una función 'helper' para crear cada pregunta/respuesta
  Widget _buildFaqTile(BuildContext context, String question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        // Esto es lo que se muestra al expandir
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              loremIpsum, // Usamos el texto de relleno
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda y Soporte')),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Preguntas Frecuentes (FAQ)',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // --- Lista de Preguntas Falsas ---
            _buildFaqTile(context, '¿Cómo se calcula mi meta de hidratación?'),
            _buildFaqTile(
              context,
              '¿Puedo editar un consumo de agua ya registrado?',
            ),
            _buildFaqTile(context, '¿Cómo funcionan los logros?'),
            _buildFaqTile(context, '¿Mis datos están seguros?'),

            // --- Sección de Contacto (Falsa) ---
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            Text(
              '¿No encontraste tu respuesta?',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contáctanos directamente a soporte@aguatorio.com para más ayuda.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
