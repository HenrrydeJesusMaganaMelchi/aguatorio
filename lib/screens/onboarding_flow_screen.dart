// lib/screens/onboarding_flow_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/services/mock_api_service.dart'; // Revisa este nombre
import 'package:aguatorio/screens/main_scaffold_screen.dart'; // La pantalla principal
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // El wrapper responsivo

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  // 1. Claves para manejar el estado
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController(); // Para el peso
  final _api = MockApiService();

  // 2. Estado para los botones de selección
  //    (Usamos 'Set' para el widget SegmentedButton)
  Set<String> _activitySelection = {'poco'}; // Valor por defecto
  Set<String> _climateSelection = {'templado'}; // Valor por defecto

  bool _isLoading = false;

  // 3. Función para finalizar
  Future<void> _handleFinish() async {
    // Valida que el campo de peso no esté vacío
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Lógica (Pausada): En un futuro, aquí llamaríamos a la API
    // para calcular la meta, pasando el peso y las selecciones.
    //
    // final double weight = double.parse(_weightController.text);
    // final String activity = _activitySelection.first;
    // final String climate = _climateSelection.first;
    // await _api.calculateAndSaveGoal(weight, activity, climate);
    //
    // Por ahora, solo fingimos un retraso:
    await Future.delayed(const Duration(seconds: 1));

    print("Onboarding completado:");
    print("Peso: ${_weightController.text} kg");
    print("Actividad: ${_activitySelection.first}");
    print("Clima: ${_climateSelection.first}");

    // --- Navegación ---
    if (mounted) {
      // Navega a la pantalla principal y borra todo el historial anterior
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScaffoldScreen()),
        (Route<dynamic> route) => false, // Borra todo
      );
    }
  }

  // 4. El constructor de la UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuéntanos sobre ti'),
        automaticallyImplyLeading: false, // Oculta flecha de 'atrás'
      ),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        // Usamos un formulario y un scroll
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- PREGUNTA 1: PESO ---
                  _buildWeightQuestion(),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // --- PREGUNTA 2: ACTIVIDAD ---
                  _buildActivityQuestion(),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // --- PREGUNTA 3: CLIMA ---
                  _buildClimateQuestion(),

                  const SizedBox(height: 48), // Espacio antes del botón
                  // --- BOTÓN FINAL ---
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleFinish,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Calcular Meta',
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

  // --- Widgets Auxiliares para cada pregunta ---

  Widget _buildWeightQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuál es tu peso actual?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: 'Peso',
            suffixText: 'kg', // Sufijo "kg"
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.monitor_weight),
          ),
          keyboardType: TextInputType.number, // Muestra teclado numérico
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tu peso';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Ingresa un peso válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActivityQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuál es tu nivel de actividad?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Usamos 'Center' para que no se estire en la web
        Center(
          child: SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment(value: 'poco', label: Text('Poco')),
              ButtonSegment(value: 'moderado', label: Text('Moderado')),
              ButtonSegment(value: 'activo', label: Text('Activo')),
            ],
            selected: _activitySelection,
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _activitySelection = newSelection;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClimateQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cómo es tu clima habitual?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Center(
          child: SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment(value: 'frio', label: Text('Frío')),
              ButtonSegment(value: 'templado', label: Text('Templado')),
              ButtonSegment(value: 'calido', label: Text('Cálido')),
            ],
            selected: _climateSelection,
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _climateSelection = newSelection;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}
