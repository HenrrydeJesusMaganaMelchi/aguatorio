import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:aguatorio/services/auth_service.dart';
import 'package:aguatorio/services/database_service.dart';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  int _selectedFilterIndex = 0; // 0: Semana, 1: Mes, 2: 3 Meses

  // Estado Real
  bool _isLoading = true;
  List<double> _chartData = [];
  int _currentStreak = 0;
  double _dailyAverage = 0;
  int _completionRate = 0;
  String _level = "Novato";

  final _authService = AuthService();
  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // 1. Determinar rango de fechas según filtro
      final now = DateTime.now();
      DateTime startDate;
      int daysInRange;

      switch (_selectedFilterIndex) {
        case 0: // Semana (Últimos 7 días)
          startDate = now.subtract(const Duration(days: 6));
          daysInRange = 7;
          break;
        case 1: // Mes (Últimos 30 días)
          startDate = now.subtract(const Duration(days: 29));
          daysInRange = 30;
          break;
        case 2: // 3 Meses (Últimos 90 días)
          startDate = now.subtract(const Duration(days: 89));
          daysInRange = 90;
          break;
        default:
          startDate = now.subtract(const Duration(days: 6));
          daysInRange = 7;
      }

      // Ajustar startDate al inicio del día (00:00:00)
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      // Ajustar endDate al final del día de hoy (23:59:59)
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // 2. Obtener logs de Firestore
      final logs = await _databaseService.getWaterLogs(
        uid: user.uid,
        startDate: startDate,
        endDate: endDate,
      );

      // 3. Procesar datos para la gráfica
      // Mapa para agrupar por día: "2023-10-27" -> totalMl
      Map<String, int> dailyTotals = {};

      // Inicializar todos los días en 0
      for (int i = 0; i < daysInRange; i++) {
        final date = startDate.add(Duration(days: i));
        final key = "${date.year}-${date.month}-${date.day}";
        dailyTotals[key] = 0;
      }

      // Sumar logs
      for (var log in logs) {
        final timestamp = log['timestamp'] as DateTime;
        final amount = log['amount'] as int;
        final key = "${timestamp.year}-${timestamp.month}-${timestamp.day}";
        if (dailyTotals.containsKey(key)) {
          dailyTotals[key] = (dailyTotals[key] ?? 0) + amount;
        }
      }

      // Convertir a lista de doubles para la gráfica (Litros)
      List<double> chartData = dailyTotals.values
          .map((ml) => ml / 1000.0)
          .toList();

      // 4. Calcular Estadísticas
      // Promedio Diario (Litros)
      double totalLitros = chartData.fold(0, (sum, val) => sum + val);
      double avg = totalLitros / daysInRange;

      // Racha (Días consecutivos cumpliendo meta > 2000ml - hardcoded por ahora)
      // Nota: Para una racha real, necesitaríamos historial más antiguo,
      // aquí calculamos la racha DENTRO del rango seleccionado o una lógica simple.
      // Vamos a contar días consecutivos desde HOY hacia atrás.
      int streak = 0;
      // Revertimos las claves para ir de hoy hacia atrás
      final sortedKeys = dailyTotals.keys.toList()
        ..sort((a, b) => b.compareTo(a)); // Descendente

      // Asumimos meta de 2000ml por defecto si no la tenemos a mano
      const dailyGoal = 2000;

      for (var key in sortedKeys) {
        if ((dailyTotals[key] ?? 0) >= dailyGoal) {
          streak++;
        } else {
          // Si es hoy y aún no llego, no rompo la racha del ayer, pero si es ayer y no llegué, fin.
          // Simplificación: Rompe si no cumple.
          final dateParts = key.split('-');
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );

          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day) {
            // Es hoy, permitimos que sea 0 si es temprano
            continue;
          }
          break;
        }
      }

      // Cumplimiento (% de días que se llegó a la meta)
      int daysMet = dailyTotals.values.where((ml) => ml >= dailyGoal).length;
      int completion = ((daysMet / daysInRange) * 100).toInt();

      // Nivel
      String level = "Novato";
      if (streak > 3) level = "Constante";
      if (streak > 7) level = "Hidratado";
      if (streak > 30) level = "Maestro";

      if (mounted) {
        setState(() {
          _chartData = chartData;
          _dailyAverage = avg;
          _currentStreak = streak;
          _completionRate = completion;
          _level = level;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error cargando estadísticas: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Fondo ligeramente gris para que resalten las tarjetas blancas
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Text(
                  'Estadísticas',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),

                // --- 1. FILTROS MODERNOS (SegmentedButton) ---
                Center(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Semana')),
                      ButtonSegment(value: 1, label: Text('Mes')),
                      ButtonSegment(value: 2, label: Text('3 Meses')),
                    ],
                    selected: {_selectedFilterIndex},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _selectedFilterIndex = newSelection.first;
                        _loadStats(); // Recargar datos al cambiar filtro
                      });
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- 2. TARJETA DE GRÁFICA ---
                Container(
                  height: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tendencia de Consumo (Litros)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: BarChart(_buildBarChartData(colorScheme)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- 3. CARDS DE PROGRESO (GRID) ---
                Text(
                  "Resumen",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Usamos un Grid dentro del ListView
                GridView.count(
                  crossAxisCount: 2, // 2 columnas
                  shrinkWrap: true, // Ocupa solo el espacio necesario
                  physics:
                      const NeverScrollableScrollPhysics(), // No scrollea por sí mismo
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio:
                      1.5, // Relación de aspecto (más ancho que alto)
                  children: [
                    _buildInsightCard(
                      context,
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                      value: "$_currentStreak Días",
                      label: "Racha Actual",
                    ),
                    _buildInsightCard(
                      context,
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      value: "${_dailyAverage.toStringAsFixed(1)} L",
                      label: "Promedio Diario",
                    ),
                    _buildInsightCard(
                      context,
                      icon: Icons.emoji_events,
                      color: Colors.purple,
                      value: "$_completionRate%",
                      label: "Cumplimiento",
                    ),
                    _buildInsightCard(
                      context,
                      icon: Icons.thumb_up,
                      color: Colors.green,
                      value: _level,
                      label: "Nivel General",
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // --- Widget para las Tarjetas Pequeñas ---
  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // --- Configuración de la Gráfica (Limpia y Moderna) ---
  BarChartData _buildBarChartData(ColorScheme colorScheme) {
    List<double> data = _chartData;

    // Si no hay datos, mostrar vacío o ceros
    if (data.isEmpty) {
      data = List.filled(7, 0.0);
    }

    double maxY = 0;
    if (data.isNotEmpty) {
      maxY = data.reduce(max).ceil().toDouble();
      maxY = max(maxY, 3.0); // Mínimo 3 litros de altura
    }

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false), // Sin bordes feos
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ), // Ocultamos eje Y para limpieza
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              // Mostrar solo algunos índices para no saturar si son muchos datos
              int index = value.toInt();
              if (index < 0 || index >= data.length) return const SizedBox();

              // Lógica simple para mostrar etiquetas
              // Si son 7 días, mostrar todos. Si son 30, mostrar cada 5.
              if (data.length > 10 && index % 5 != 0) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  (index + 1).toString(), // Día relativo 1, 2, 3...
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      barGroups: List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data[index],
              // Gradiente en las barras para modernidad
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: data.length > 20
                  ? 6
                  : 14, // Barras más finas si hay muchos datos
              borderRadius: BorderRadius.circular(6), // Bordes redondeados
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY, // Fondo gris hasta el tope
                color: Colors.grey.withOpacity(0.05),
              ),
            ),
          ],
        );
      }),
    );
  }
}
