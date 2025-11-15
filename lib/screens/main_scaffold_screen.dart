// lib/screens/main_scaffold_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/screens/home_tab.dart';
import 'package:aguatorio/screens/stats_tab.dart';
import 'package:aguatorio/screens/achievements_tab.dart';
import 'package:aguatorio/screens/profile_tab.dart';

class MainScaffoldScreen extends StatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  State<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends State<MainScaffoldScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const StatsTab(),
    const AchievementsTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Widget constrainedContent = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        );

        // --- CASO 1: PANTALLA MÓVIL (PEQUEÑA) ---
        if (constraints.maxWidth < 600) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Aguatorio'),
              automaticallyImplyLeading: false,
            ),
            body: constrainedContent,

            // --- INICIO DE LA CORRECCIÓN ---
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Estadísticas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events),
                  label: 'Logros',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,

              // (Las líneas 'selectedItemColor' y 'unselectedItemColor'
              //  se han ELIMINADO de aquí. Ahora obedecerán al
              //  tema que definimos en main.dart)
            ),
            // --- FIN DE LA CORRECCIÓN ---
          );
        }
        // --- CASO 2: PANTALLA WEB (ANCHA) ---
        else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Aguatorio'),
              automaticallyImplyLeading: false,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bar_chart_outlined),
                      selectedIcon: Icon(Icons.bar_chart),
                      label: Text('Estadísticas'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events),
                      label: Text('Logros'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),

                const VerticalDivider(thickness: 1, width: 1),

                Expanded(child: constrainedContent),
              ],
            ),
          );
        }
      },
    );
  }
}
