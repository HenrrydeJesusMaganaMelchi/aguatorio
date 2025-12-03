// lib/screens/home_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Ocultamos LinearGradient de Rive para usar el de Flutter en el fondo de la tarjeta
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:aguatorio/services/auth_service.dart';
import 'package:aguatorio/services/database_service.dart';
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
  String _userName = 'Usuario';

  final _authService = AuthService();
  final _databaseService = DatabaseService();

  // --- Variables de Rive ---
  Artboard? _riveArtboard;
  SMIInput<double>? _riveInput;

  @override
  void initState() {
    super.initState();
    // Cargamos la animación y los datos al iniciar
    _loadRiveFile();
    _fetchSummary();
  }

  // --- Carga del archivo Rive ---
  Future<void> _loadRiveFile() async {
    try {
      final data = await rootBundle.load('assets/animations/vaso.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      // Buscamos la Máquina de Estados llamada 'percentage'
      var controller = StateMachineController.fromArtboard(
        artboard,
        'percentage',
      );

      if (controller != null) {
        artboard.addController(controller);
        // Buscamos la entrada numérica llamada 'percentage'
        _riveInput = controller.findInput<double>('percentage');
      }

      setState(() => _riveArtboard = artboard);

      // Si los datos llegaron antes que la animación, actualizamos ahora
      _updateRiveAnimation();
    } catch (e) {
      print("Error cargando Rive: $e");
    }
  }

  // --- Carga de Datos del Backend ---
  Future<void> _fetchSummary() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener el usuario actual
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener el perfil del usuario de Firestore
      final profile = await _databaseService.getUserProfile(user.uid);
      if (profile == null) {
        throw Exception('Perfil de usuario no encontrado');
      }

      // Obtener la meta diaria de agua (por defecto 2000 ml si no está configurada)
      final dailyGoal = profile['dailyWaterGoal'] as int? ?? 2000;
      final userName =
          profile['name'] as String? ?? user.displayName ?? 'Usuario';

      // Por ahora, usamos valores mock para el consumo actual
      // Tu compañero implementará la lógica de logs de agua
      final summary = DailySummary(
        date: DateTime.now(),
        goalMl: dailyGoal,
        totalConsumedMl: (profile['totalConsumedMl'] as num?)?.toInt() ?? 0,
        hourlyBreakdown: {},
      );

      if (mounted) {
        setState(() {
          _summary = summary;
          _userName = userName;
          _isLoading = false;
        });
        // Actualizamos la animación con los nuevos datos
        _updateRiveAnimation();
      }
    } catch (e) {
      print('Error en _fetchSummary: $e');
      if (mounted) {
        setState(() {
          _errorMessage = "Error al cargar datos: $e";
          _isLoading = false;
        });
      }
    }
  }

  // --- Actualizar el nivel de agua en Rive ---
  void _updateRiveAnimation() {
    if (_riveInput != null && _summary != null) {
      final goal = _summary!.goalMl > 0 ? _summary!.goalMl : 1;
      // Calculamos el porcentaje (0 a 100)
      final percentageValue =
          (_summary!.totalConsumedMl / goal).clamp(0.0, 1.0) * 100;

      // Le pasamos el valor a la animación
      _riveInput!.value = percentageValue;
    }
  }

  // --- Botón de Agregar ---
  void _addWaterLog() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddWaterLogScreen()));
    // Al volver, recargamos los datos
    _fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo sutil en modo claro para que resalte la tarjeta
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : null,
      body: _buildBody(),

      // Botón Flotante Moderno
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
    // Muestra carga solo si no tenemos ni datos ni animación lista
    if (_isLoading && _summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final summary = _summary!;
    // Porcentaje para el texto
    final percentDisplay =
        ((summary.totalConsumedMl / summary.goalMl).clamp(0.0, 1.0) * 100)
            .toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TARJETA PRINCIPAL (Dashboard) ---
          Container(
            width: double.infinity,
            height: 480, // Altura suficiente para todo el contenido
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
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
                // Decoración de fondo (Círculo sutil)
                Positioned(
                  top: -50,
                  right: -50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),

                // Contenido de la Tarjeta
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Header Interno (Saludo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, $_userName 👋',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mantente hidratado hoy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // 2. Vaso Animado Rive
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 250,
                            width: 250,
                            child: _riveArtboard == null
                                ? const SizedBox() // Esperando carga...
                                : Rive(
                                    artboard: _riveArtboard!,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),

                      // 3. Datos Numéricos
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

          // --- Resumen Rápido (Tarjetas Pequeñas) ---
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
          // Espacio extra para el FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Widget auxiliar para tarjetas pequeñas
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
