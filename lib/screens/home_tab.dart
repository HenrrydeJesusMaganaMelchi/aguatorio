// lib/screens/home_tab.dart

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchSummary();
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

  void _addWaterLog() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddWaterLogScreen()));
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
    if (_isLoading) {
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
      // Nos aseguramos que la meta sea al menos 1 para evitar dividir por cero
      final goal = summary.goalMl > 0 ? summary.goalMl : 1;
      final percentage = (summary.totalConsumedMl / goal).clamp(0.0, 1.0);

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

            // --- 7. EL VASO QUE SE LLENA (¡LÓGICA CORREGIDA!) ---
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // --- Capa 1: El AGUA (al fondo, animada) ---
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: percentage),
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeInOut,
                    builder: (context, animatedPercentage, child) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: animatedPercentage,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/vaso_lleno.png', // <-- ¡TU NUEVA IMAGEN DE AGUA!
                      fit: BoxFit.contain,
                    ),
                  ),

                  // --- Capa 2: El CONTORNO DEL VASO (encima) ---
                  Image.asset(
                    'assets/images/vaso_vacio.png', // <-- ¡TU NUEVO CONTORNO!
                    fit: BoxFit.contain,
                  ),

                  // --- Capa 3: El texto (encima de todo) ---
                  // (¡Mi código SÍ usa los widgets de texto!)
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
