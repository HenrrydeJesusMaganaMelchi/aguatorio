import 'package:flutter/material.dart';
import 'package:aguatorio/services/mock_api_service.dart';
import 'package:aguatorio/models/achievement.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  late Future<List<Achievement>> _achievementsFuture;
  final _api = MockApiService();

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _api.getAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logros',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Achievement>>(
                future: _achievementsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) return const Text("Sin datos");

                  final achievements = snapshot.data!;

                  // --- GRID MODERNO ---
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columnas
                          childAspectRatio: 0.85, // Tarjetas un poco altas
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      return _buildAchievementCard(achievements[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isEarned = achievement.isEarned;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        // Si no está ganado, lo hacemos grisáceo y transparente
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono con círculo de fondo
          CircleAvatar(
            radius: 35,
            backgroundColor: isEarned
                ? Colors.orange.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 40,
              color: isEarned ? Colors.orange : Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isEarned ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
