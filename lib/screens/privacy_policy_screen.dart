// lib/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // Texto de relleno
  final String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      "\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.";

  // Una función 'helper' para crear los títulos
  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Una función 'helper' para crear el texto de cuerpo
  Widget _buildBodyText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        height: 1.5, // Interlineado para que sea más fácil de leer
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidad')),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        // Usamos SingleChildScrollView para que el texto sea 'scrolleable'
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Sección 1 ---
              _buildTitle(context, '1. Información que Recopilamos'),
              _buildBodyText(context, loremIpsum),

              // --- Sección 2 ---
              _buildTitle(context, '2. Cómo Usamos su Información'),
              _buildBodyText(context, loremIpsum),

              // --- Sección 3 ---
              _buildTitle(context, '3. Seguridad de sus Datos'),
              _buildBodyText(context, loremIpsum),

              // --- Sección 4 ---
              _buildTitle(context, '4. Cambios a esta Política'),
              _buildBodyText(context, loremIpsum),
            ],
          ),
        ),
      ),
    );
  }
}
