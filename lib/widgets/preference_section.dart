// lib/widgets/preference_section.dart
import 'package:flutter/material.dart';

class PreferenceSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final Set<String> selectedOptions; // El padre (la pantalla) guarda el estado
  final Function(String) onOptionTapped; // El padre maneja la lógica

  const PreferenceSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Título de la sección
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // 2. Chips de selección
        Wrap(
          spacing: 12.0, // Espacio horizontal
          runSpacing: 12.0, // Espacio vertical
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);

            return FilterChip(
              label: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                // Llama a la función del padre para actualizar el estado
                onOptionTapped(option);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor,
              checkmarkColor: Colors.white,
              pressElevation: 5.0,
            );
          }).toList(),
        ),
      ],
    );
  }
}
