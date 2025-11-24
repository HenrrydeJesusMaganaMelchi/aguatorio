import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  int _selectedFilterIndex = 0; // 0: Semana, 1: Mes, 2: 3 Meses

  // Datos Falsos
  final List<double> _fakeWeeklyData = [2.1, 1.8, 2.5, 2.2, 1.9, 3.0, 2.7];
  final List<double> _fakeMonthlyData = [1.2, 1.9, 1.5, 1.3];
  final List<double> _fakeQuarterlyData = [3.1, 4.4, 3.3];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Fondo ligeramente gris para que resalten las tarjetas blancas
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF5F7FA)
          : null,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            'Estadísticas',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
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
                  "Tendencia de Consumo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(child: BarChart(_buildBarChartData(colorScheme))),
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
            childAspectRatio: 1.5, // Relación de aspecto (más ancho que alto)
            children: [
              _buildInsightCard(
                context,
                icon: Icons.local_fire_department,
                color: Colors.orange,
                value: "12 Días",
                label: "Racha Actual",
              ),
              _buildInsightCard(
                context,
                icon: Icons.water_drop,
                color: Colors.blue,
                value: "2.1 L",
                label: "Promedio Diario",
              ),
              _buildInsightCard(
                context,
                icon: Icons.emoji_events,
                color: Colors.purple,
                value: "85%",
                label: "Cumplimiento",
              ),
              _buildInsightCard(
                context,
                icon: Icons.thumb_up,
                color: Colors.green,
                value: "Excelente",
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
    List<double> data;
    // ... (Lógica de selección de datos igual que antes)
    switch (_selectedFilterIndex) {
      case 0:
        data = _fakeWeeklyData;
        break;
      case 1:
        data = _fakeMonthlyData;
        break;
      case 2:
        data = _fakeQuarterlyData;
        break;
      default:
        data = [];
    }

    double maxY = 0;
    if (data.isNotEmpty) {
      maxY = data.reduce(max).ceil().toDouble();
      maxY = max(maxY, 2.0);
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
              // (Aquí iría tu lógica de Lun/Mar, la simplifico por espacio)
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
              width: 14,
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
