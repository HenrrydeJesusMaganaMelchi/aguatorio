// lib/screens/profile_tab.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/services/theme_service.dart';
import 'package:provider/provider.dart';

// Importa las nuevas pantallas
import 'package:aguatorio/screens/edit_profile_screen.dart';
import 'package:aguatorio/screens/notifications_screen.dart';
import 'package:aguatorio/screens/edit_goal_screen.dart'; // <-- IMPORTADO
import 'package:aguatorio/screens/privacy_policy_screen.dart';
import 'package:aguatorio/screens/help_support_screen.dart';
import 'package:aguatorio/screens/hydration_info_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  // --- Función genérica para construir los botones ---
  // (La dejaremos para Privacidad y Ayuda)
  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool hasTrailing = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: hasTrailing
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: () {
        // Lógica pausada para estos
        print("Tocado: $title");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia del servicio de tema
    final themeService = Provider.of<ThemeService>(context);

    return ListView(
      children: [
        // --- 1. Encabezado del Perfil ---
        Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'Usuario de Prueba',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'test@test.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navega a la pantalla de Editar Perfil
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: const Text('Editar Perfil'),
              ),
            ],
          ),
        ),

        const Divider(thickness: 1),

        // --- 2. Opciones de Configuración ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              // --- Widget de Modo Oscuro ---
              ListTile(
                leading: Icon(
                  themeService.themeMode == ThemeMode.dark
                      ? Icons.brightness_7
                      : Icons.brightness_4,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Modo Oscuro',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Switch(
                  value: themeService.themeMode == ThemeMode.dark,
                  onChanged: (bool isDark) {
                    Provider.of<ThemeService>(
                      context,
                      listen: false,
                    ).toggleTheme(isDark);
                  },
                ),
              ),

              // --- Widget de Notificaciones ---
              ListTile(
                leading: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Notificaciones',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),

              // --- WIDGET MODIFICADO: PERSONALIZAR META ---
              ListTile(
                leading: Icon(
                  Icons.track_changes,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Personalizar Meta',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navega a la nueva pantalla de "Editar Meta"
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditGoalScreen(),
                    ),
                  );
                },
              ),

              // --- FIN DE LA MODIFICACIÓN ---
              ListTile(
                leading: Icon(
                  Icons.shield_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Privacidad', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Información de Hidratación',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HydrationInfoScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Ayuda y Soporte',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 24),

              // --- 3. Botón de Cerrar Sesión ---
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                onTap: () {
                  print("Tocado: Cerrar Sesión");
                  // Lógica futura de logout aquí...
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
