// lib/screens/home_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para cargar el archivo Rive
import 'package:rive/rive.dart'; // <-- 1. Importa Rive
import 'package:aguatorio/services/mock_api_service.dart';
import 'package:aguatorio/models/daily_summary.dart';
import 'package:aguatorio/screens/add_water_log_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = true;
  DailySummary? _summary;
  String? _errorMessage;

  final _api = MockApiService();

  // --- 2. Variables de Rive ---
  Artboard? _riveArtboard; // El "lienzo" de la animación
  SMIInput<double>? _riveInput; // La entrada "percentage"

  @override
  void initState() {
    super.initState();
    // 3. Carga el archivo .riv PRIMERO
    _loadRiveFile();
    // Luego, carga los datos del resumen
    _fetchSummary();
  }

  // --- 4. Función para cargar el archivo Rive ---
  Future<void> _loadRiveFile() async {
    // Carga el archivo desde tus assets
    // ¡ASEGÚRATE DE QUE EL NOMBRE DEL ARCHIVO SEA CORRECTO!
    final data = await rootBundle.load('assets/animations/vaso.riv');
    final file = RiveFile.import(data);

    // Encuentra el "Artboard" principal (el lienzo)
    final artboard = file.mainArtboard;
    // Encuentra el "State Machine" (asumimos que se llama 'State Machine 1')
    var controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );

    if (controller != null) {
      artboard.addController(controller);
      // --- 5. ¡LA CONEXIÓN CLAVE! ---
      // Busca la entrada llamada "percentage"
      _riveInput = controller.findInput<double>('percentage');
    }

    setState(() => _riveArtboard = artboard);
  }

  Future<void> _fetchSummary() async {
    // ... (esta función no cambia)
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final summary = await _api.getDailySummary(DateTime.now());
      if (mounted) {
        setState(() {
          _summary = summary;
          _isLoading = false;
        });
        // --- 6. ACTUALIZA RIVE ---
        _updateRiveAnimation();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al cargar el resumen";
          _isLoading = false;
        });
      }
    }
  }

  // --- 7. Función que pasa el porcentaje a Rive ---
  void _updateRiveAnimation() {
    if (_riveInput != null && _summary != null) {
      final goal = _summary!.goalMl > 0 ? _summary!.goalMl : 1;
      // Calcula el porcentaje (ej. 0.45) y lo multiplica por 100
      final percentageValue =
          (_summary!.totalConsumedMl / goal).clamp(0.0, 1.0) * 100;

      // ¡Le da el valor a la animación!
      _riveInput!.value = percentageValue;
    }
  }

  void _addWaterLog() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddWaterLogScreen()));
    // Vuelve a cargar los datos Y actualiza la animación
    _fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWaterLog,
        child: const Icon(Icons.add, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    // Caso 1: Está cargando (espera a la API y a Rive)
    if (_isLoading || _riveArtboard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    if (_summary != null) {
      final summary = _summary!;

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¡Hola, Usuario!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu progreso de hoy:',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 40),

            // --- 8. EL VASO DE RIVE ---
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // --- Capa 1: La Animación Rive ---
                  _riveArtboard == null
                      ? const SizedBox()
                      : Rive(artboard: _riveArtboard!),

                  // --- Capa 2: El texto (encima de todo) ---
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${summary.totalConsumedMl} ml',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          'de ${summary.goalMl} ml',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const Center(child: Text('No hay datos.'));
  }
}
