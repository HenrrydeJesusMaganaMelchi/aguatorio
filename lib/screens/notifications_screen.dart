// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // 1. Estado local (solo visual) para "recordar" los switches
  bool _generalReminders = true;
  bool _morningReminder = true;
  bool _eveningReminder = true;
  bool _achievementAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones y Recordatorios')),
      // Usamos el Wrapper para que se vea bien en web
      body: ResponsiveLayoutWrapper(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            // --- Interruptor General ---
            // 'SwitchListTile' es un widget perfecto que combina
            // un título, un subtítulo y un switch.
            SwitchListTile(
              title: const Text(
                'Recordatorios Generales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Activa o desactiva todos los recordatorios',
              ),
              value: _generalReminders,
              onChanged: (bool newValue) {
                // Lógica visual: actualiza el estado local
                setState(() {
                  _generalReminders = newValue;

                  // (Lógica pausada): En un futuro, esto activaría/desactivaría
                  // los interruptores de abajo también.
                });
              },
            ),

            const Divider(),

            // --- Interruptores Específicos ---
            // Usamos 'Opacity' para simular que dependen del general
            Opacity(
              opacity: _generalReminders ? 1.0 : 0.5,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Recordatorio matutino'),
                    subtitle: const Text('8:00 AM - 12:00 PM'),
                    value: _morningReminder,
                    // 'onChanged' se deshabilita si _generalReminders es false
                    onChanged: _generalReminders
                        ? (bool newValue) {
                            setState(() {
                              _morningReminder = newValue;
                            });
                          }
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Recordatorio vespertino'),
                    subtitle: const Text('1:00 PM - 8:00 PM'),
                    value: _eveningReminder,
                    onChanged: _generalReminders
                        ? (bool newValue) {
                            setState(() {
                              _eveningReminder = newValue;
                            });
                          }
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Alertas de logros'),
                    subtitle: const Text('Recibir alertas al ganar un logro'),
                    value: _achievementAlerts,
                    onChanged: _generalReminders
                        ? (bool newValue) {
                            setState(() {
                              _achievementAlerts = newValue;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
