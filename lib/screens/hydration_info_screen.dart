// lib/screens/hydration_info_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class HydrationInfoScreen extends StatelessWidget {
  const HydrationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los estilos de texto para reusarlos
    final titleStyle = Theme.of(
      context,
    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.5, // Interlineado
      color: Colors.grey[700], // Un gris oscuro para legibilidad
    );

    // En modo oscuro, el texto del cuerpo debe ser más claro
    final bodyStyleDark = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.5,
      color: Colors.grey[300], // Un gris claro para modo oscuro
    );

    // Decide qué estilo de cuerpo usar basado en el tema
    final currentBodyStyle = Theme.of(context).brightness == Brightness.dark
        ? bodyStyleDark
        : bodyStyle;

    return Scaffold(
      appBar: AppBar(title: const Text('Información de Hidratación')),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        // Usamos SingleChildScrollView para que el texto sea 'scrolleable'
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Título Principal ---
              Text(
                '¿Cuántos litros de agua debo tomar al día realmente?',
                style: titleStyle,
              ),
              const SizedBox(height: 16),

              // --- Párrafo 1 ---
              Text(
                'La cantidad que necesita un adulto sano depende de su peso corporal. Según la OMS, la recomendación general es de 35 ml por cada kilo. Esto significa que, por ejemplo, una persona de 50 kg debe beber 1.7 litros de agua al día, mientras que una de 80 kg debe beber 2.8 litros. Puedes calcular la cantidad de agua que necesitas con esta fórmula:',
                style: currentBodyStyle,
              ),
              const SizedBox(height: 24),

              // --- Fórmula ---
              Center(
                child: Text(
                  'Agua (litros) = Peso (kg) * 0.035',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Imagen 1: Infografía de Siluetas ---
              // Asegúrate de que el nombre del archivo sea correcto
              Image.asset(
                'assets/images/info_silhouette.png',
                fit: BoxFit.contain, // Ajusta la imagen al ancho
              ),
              const SizedBox(height: 24),

              // --- Párrafo 2 ---
              Text(
                'Si quieres estimular tu consumo de agua, prueba beber un vaso entre cada comida, asimismo puedes tomar agua antes, durante y después del ejercicio. Te sorprenderá saber que algunas veces confundimos la sed con el hambre.',
                style: currentBodyStyle,
              ),
              const SizedBox(height: 16),
              Text(
                '¡No olvides beber agua a lo largo de tu día!',
                style: currentBodyStyle?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // --- Imagen 2: Infografía de Frutas ---
              // Asegúrate de que el nombre del archivo sea correcto
              Image.asset('assets/images/info_fruits.png', fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }
}
