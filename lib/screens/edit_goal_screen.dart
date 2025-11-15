// lib/screens/edit_goal_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class EditGoalScreen extends StatefulWidget {
  const EditGoalScreen({super.key});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  // 1. Claves para manejar el estado
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // 2. Estado para los botones de selección
  Set<String> _activitySelection = {'poco'}; // Valor por defecto
  Set<String> _climateSelection = {'templado'}; // Valor por defecto
  Set<String> _healthSelection = {'ninguno'}; // Valor por defecto

  bool _isLoading = false;

  // 3. Función para "Guardar" (solo imprime)
  void _handleRecalculate() {
    FocusScope.of(context).unfocus(); // Oculta el teclado

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Lógica (Pausada): En un futuro, aquí llamaríamos a la API
      // con TODOS estos datos para recalcular la meta.
      print("Recalculando meta...");
      print(
        "Peso: ${_weightController.text}, Edad: ${_ageController.text}, Altura: ${_heightController.text}",
      );
      print(
        "Actividad: ${_activitySelection.first}, Clima: ${_climateSelection.first}",
      );

      // Simula un retraso de red
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Meta recalculada (simulado)"),
            backgroundColor: Colors.green,
          ),
        );
        // Cierra la pantalla
        Navigator.of(context).pop();
      });
    }
  }

  // 4. Llenar los campos con datos falsos al inicio
  @override
  void initState() {
    super.initState();
    // (Lógica Futura): Aquí cargaríamos los datos reales del usuario
    _weightController.text = "75"; // Placeholder
    _ageController.text = "30"; // Placeholder
    _heightController.text = "175"; // Placeholder
  }

  // 5. El constructor de la UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalizar Meta')),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- PREGUNTA 1: PESO ---
                  _buildTextField(
                    controller: _weightController,
                    label: 'Peso',
                    suffix: 'kg',
                    icon: Icons.monitor_weight,
                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 16),

                  // --- PREGUNTA 2: EDAD ---
                  _buildTextField(
                    controller: _ageController,
                    label: 'Edad',
                    suffix: 'años',
                    icon: Icons.cake,
                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 16),

                  // --- PREGUNTA 3: ALTURA ---
                  _buildTextField(
                    controller: _heightController,
                    label: 'Altura',
                    suffix: 'cm',
                    icon: Icons.height,
                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // --- PREGUNTA 4: ACTIVIDAD ---
                  _buildSegmentedQuestion(
                    title: '¿Cuál es tu nivel de actividad?',
                    selection: _activitySelection,
                    segments: const [
                      ButtonSegment(value: 'poco', label: Text('Poco')),
                      ButtonSegment(value: 'moderado', label: Text('Moderado')),
                      ButtonSegment(value: 'activo', label: Text('Activo')),
                    ],
                    onChanged: (newSelection) {
                      setState(() {
                        _activitySelection = newSelection;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // --- PREGUNTA 5: CLIMA ---
                  _buildSegmentedQuestion(
                    title: '¿Cómo es tu clima habitual?',
                    selection: _climateSelection,
                    segments: const [
                      ButtonSegment(value: 'frio', label: Text('Frío')),
                      ButtonSegment(value: 'templado', label: Text('Templado')),
                      ButtonSegment(value: 'calido', label: Text('Cálido')),
                    ],
                    onChanged: (newSelection) {
                      setState(() {
                        _climateSelection = newSelection;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // --- PREGUNTA 6: SALUD ESPECIAL ---
                  _buildSegmentedQuestion(
                    title: '¿Condición especial?',
                    selection: _healthSelection,
                    segments: const [
                      ButtonSegment(value: 'ninguno', label: Text('Ninguno')),
                      ButtonSegment(value: 'embarazo', label: Text('Embarazo')),
                      ButtonSegment(
                        value: 'lactancia',
                        label: Text('Lactancia'),
                      ),
                    ],
                    onChanged: (newSelection) {
                      setState(() {
                        _healthSelection = newSelection;
                      });
                    },
                  ),

                  const SizedBox(height: 48), // Espacio antes del botón
                  // --- BOTÓN FINAL ---
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleRecalculate,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Recalcular Meta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets Auxiliares Reutilizables ---

  // Validador genérico para campos numéricos
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Ingresa un número válido';
    }
    return null;
  }

  // Plantilla para los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.number,
      validator: validator,
    );
  }

  // Plantilla para las preguntas de botones
  Widget _buildSegmentedQuestion({
    required String title,
    required Set<String> selection,
    required List<ButtonSegment<String>> segments,
    required void Function(Set<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Center(
          child: SegmentedButton<String>(
            segments: segments,
            selected: selection,
            onSelectionChanged: onChanged,
            // Permite que los botones se ajusten en pantallas pequeñas
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
