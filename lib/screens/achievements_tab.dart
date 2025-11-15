// lib/screens/achievements_tab.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/services/mock_api_service.dart'; // <-- Revisa este nombre!
import 'package:aguatorio/models/achievement.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  // 1. Estado para manejar la carga de datos
  //    Usamos un 'Future' para que sea más fácil de usar con un FutureBuilder
  late final Future<List<Achievement>> _achievementsFuture;

  // 2. El servicio
  final _api = MockApiService();

  // 3. Función para cargar los datos cuando la pantalla inicia
  @override
  void initState() {
    super.initState();
    _fetchAchievements();
  }

  // Asigna el 'Future' a nuestra variable
  void _fetchAchievements() {
    _achievementsFuture = _api.getAchievements();
  }

  // Función para "reintentar" en caso de error
  void _retry() {
    setState(() {
      _fetchAchievements(); // Vuelve a llamar a la API
    });
  }

  // 4. El constructor de la UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Título ---
            Text(
              'Logros',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 5. FutureBuilder
            //    Este widget es perfecto para manejar estados de carga.
            Expanded(
              child: FutureBuilder<List<Achievement>>(
                future: _achievementsFuture, // Le decimos qué 'Future' esperar
                builder: (context, snapshot) {
                  // Caso 1: Está cargando
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Caso 2: Hubo un error
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Error al cargar los logros',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _retry,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Caso 3: Datos cargados (snapshot.hasData)
                  if (snapshot.hasData) {
                    final achievements = snapshot.data!;

                    // Mostramos la lista
                    return ListView.builder(
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        // Usamos un widget separado para la tarjeta
                        return _buildAchievementCard(achievement);
                      },
                    );
                  }

                  // Caso 4: No hay datos (poco probable)
                  return const Center(child: Text('No hay logros.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Widget de UI para la Tarjeta de Logro
  Widget _buildAchievementCard(Achievement achievement) {
    // Decide la opacidad basado en si se ganó
    final opacity = achievement.isEarned ? 1.0 : 0.4;

    // Icono de medalla de ejemplo
    final icon = Icon(
      Icons.emoji_events,
      size: 50,
      color: achievement.isEarned ? Colors.amber[700] : Colors.grey[600],
    );

    return Opacity(
      opacity: opacity, // Aplica la opacidad a toda la tarjeta
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // --- Icono ---
              icon,
              const SizedBox(width: 16),

              // --- Textos ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              // --- Check (si se ganó) ---
              if (achievement.isEarned)
                const Icon(Icons.check_circle, color: Colors.green, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
