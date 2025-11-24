import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aguatorio/services/theme_service.dart';
// Importa tus pantallas aquí (EditProfile, Notifications, etc.)
// import ...

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFF5F7FA),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Perfil',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),

          // --- TARJETA DE USUARIO ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuario de Prueba',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'test@test.com',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    /* Navegar a editar */
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- SECCIÓN: PREFERENCIAS ---
          _buildSectionTitle(context, "General"),
          _buildSettingsGroup(context, [
            _buildTile(
              context,
              icon: Icons.track_changes,
              title: "Personalizar Meta",
              onTap: () {},
            ),
            _buildTile(
              context,
              icon: Icons.notifications_outlined,
              title: "Notificaciones",
              onTap: () {},
            ),
            // Switch de Modo Oscuro
            SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text(
                "Modo Oscuro",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              value: themeService.themeMode == ThemeMode.dark,
              onChanged: (val) => themeService.toggleTheme(val),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // --- SECCIÓN: SOPORTE ---
          _buildSectionTitle(context, "Soporte"),
          _buildSettingsGroup(context, [
            _buildTile(
              context,
              icon: Icons.shield_outlined,
              title: "Privacidad",
              onTap: () {},
            ),
            _buildTile(
              context,
              icon: Icons.help_outline,
              title: "Ayuda",
              onTap: () {},
            ),
            _buildTile(
              context,
              icon: Icons.info_outline,
              title: "Información",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // --- BOTÓN CERRAR SESIÓN ---
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              "Cerrar Sesión",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
    );
  }
}
