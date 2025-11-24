// lib/screens/home_tab.dart

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
=======
import 'package:flutter/services.dart'; // Necesario para cargar el archivo Rive
import 'package:rive/rive.dart'; // <-- 1. Importa Rive
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
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

<<<<<<< HEAD
  Artboard? _riveArtboard;
  SMIInput<double>? _riveInput;
=======
  // --- 2. Variables de Rive ---
  Artboard? _riveArtboard; // El "lienzo" de la animación
  SMIInput<double>? _riveInput; // La entrada "percentage"
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadRiveFile();
    _fetchSummary();
  }

  Future<void> _loadRiveFile() async {
    try {
      final data = await rootBundle.load('assets/animations/vaso.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'percentage',
      );

      if (controller != null) {
        artboard.addController(controller);
        _riveInput = controller.findInput<double>('percentage');
      }
      setState(() => _riveArtboard = artboard);
      _updateRiveAnimation();
    } catch (e) {
      print("Error cargando Rive: $e");
    }
=======
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
      'percentage',
    );

    if (controller != null) {
      artboard.addController(controller);
      // --- 5. ¡LA CONEXIÓN CLAVE! ---
      // Busca la entrada llamada "percentage"
      _riveInput = controller.findInput<double>('percentage');
    }

    setState(() => _riveArtboard = artboard);
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
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
<<<<<<< HEAD
=======
        // --- 6. ACTUALIZA RIVE ---
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
        _updateRiveAnimation();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al cargar datos";
          _isLoading = false;
        });
      }
    }
  }

<<<<<<< HEAD
  void _updateRiveAnimation() {
    if (_riveInput != null && _summary != null) {
      final goal = _summary!.goalMl > 0 ? _summary!.goalMl : 1;
      final percentageValue =
          (_summary!.totalConsumedMl / goal).clamp(0.0, 1.0) * 100;
=======
  // --- 7. Función que pasa el porcentaje a Rive ---
  void _updateRiveAnimation() {
    if (_riveInput != null && _summary != null) {
      final goal = _summary!.goalMl > 0 ? _summary!.goalMl : 1;
      // Calcula el porcentaje (ej. 0.45) y lo multiplica por 100
      final percentageValue =
          (_summary!.totalConsumedMl / goal).clamp(0.0, 1.0) * 100;

      // ¡Le da el valor a la animación!
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
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
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : null,
      body: _buildBody(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addWaterLog,
        icon: const Icon(Icons.water_drop),
        label: const Text(
          "Registrar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildBody() {
<<<<<<< HEAD
    if (_isLoading && _summary == null) {
=======
    // Caso 1: Está cargando (espera a la API y a Rive)
    if (_isLoading || _riveArtboard == null) {
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

<<<<<<< HEAD
    final summary = _summary!;
    final percentDisplay =
        ((summary.totalConsumedMl / summary.goalMl).clamp(0.0, 1.0) * 100)
            .toInt();
=======
    if (_summary != null) {
      final summary = _summary!;
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (YA NO HAY HEADER EXTERNO AQUÍ)
          const SizedBox(height: 10),

<<<<<<< HEAD
          // --- TARJETA PRINCIPAL (GRADIENTE) ---
          Container(
            width: double.infinity,
            height: 450, // Aumentamos altura para que quepa el header
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
=======
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
>>>>>>> 5b39aae73a5e84acbbd71e187748f4b663929b70
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decoración de fondo
                Positioned(
                  top: -50,
                  right: -50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),

                // --- CONTENIDO DE LA TARJETA ---
                Padding(
                  padding: const EdgeInsets.all(24.0), // Margen interno
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Distribuye el espacio
                    children: [
                      // 1. HEADER INTERNO (Hola Usuario)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hola, Usuario 👋',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white, // Texto Blanco
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mantente hidratado hoy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(
                                    0.8,
                                  ), // Blanco semi-transparente
                                ),
                              ),
                            ],
                          ),
                          // Icono de perfil en blanco
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // 2. EL VASO RIVE
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 220,
                            width: 220,
                            child: _riveArtboard == null
                                ? const SizedBox()
                                : Rive(
                                    artboard: _riveArtboard!,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),

                      // 3. DATOS DE PROGRESO
                      Column(
                        children: [
                          Text(
                            '$percentDisplay%',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${summary.totalConsumedMl} / ${summary.goalMl} ml',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- Resumen Rápido ---
          Text(
            "Detalles",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.flag,
                  label: "Meta",
                  value: "${summary.goalMl}",
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.water_drop,
                  label: "Faltan",
                  value:
                      "${(summary.goalMl - summary.totalConsumedMl).clamp(0, 9999)}",
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
