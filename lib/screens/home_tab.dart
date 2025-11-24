// lib/screens/home_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
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

  Artboard? _riveArtboard;
  SMIInput<double>? _riveInput;

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> _fetchSummary() async {
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

  void _updateRiveAnimation() {
    if (_riveInput != null && _summary != null) {
      final goal = _summary!.goalMl > 0 ? _summary!.goalMl : 1;
      final percentageValue =
          (_summary!.totalConsumedMl / goal).clamp(0.0, 1.0) * 100;
      _riveInput!.value = percentageValue;
    }
  }

  void _addWaterLog() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddWaterLogScreen()));
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
    if (_isLoading && _summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final summary = _summary!;
    final percentDisplay =
        ((summary.totalConsumedMl / summary.goalMl).clamp(0.0, 1.0) * 100)
            .toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (YA NO HAY HEADER EXTERNO AQUÍ)
          const SizedBox(height: 10),

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
