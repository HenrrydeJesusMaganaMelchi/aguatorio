// lib/screens/stats_tab.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math'; // Importa 'dart:math' para la función max()
// NO importamos 'toggle_switch'

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  // 1. Estado para el SegmentedButton
  //    (Funciona con un Set, 0 = Semana)
  Set<int> _filterSelection = {0};

  // --- 2. DATOS FALSOS (MAQUETACIÓN) ---
  final List<double> _fakeWeeklyData = [2.1, 1.8, 8.5, 2.2, 1.9, 3.0, 2.7];
  final List<double> _fakeMonthlyData = [5.2, 1.9, 1.5, 1.3];
  final List<double> _fakeQuarterlyData = [3.1, 10.4, 3.3];

  // --- 3. El constructor de la UI ---
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // --- Título ---
        Text(
          'Estadísticas',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // --- 4. Filtros (NUEVO WIDGET: SegmentedButton) ---
        // Lo centramos para que no se estire
        Center(
          child: SegmentedButton<int>(
            // Los 3 botones que se mostrarán
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(
                value: 0, // El índice
                label: Text('Semana'),
                icon: Icon(Icons.calendar_view_week),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Mes'),
                icon: Icon(Icons.calendar_view_month),
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text('3 Meses'),
                icon: Icon(Icons.calendar_today),
              ),
            ],

            // El Set que guarda la selección
            selected: _filterSelection,

            // Lógica para actualizar el estado
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                // 'multiSelectionEnabled: false' (por defecto)
                // asegura que 'newSelection' siempre tenga 1 solo item.
                _filterSelection = newSelection;
              });
            },
          ),
        ),
        const SizedBox(height: 40),

        // --- 5. Gráfica de Barras Dinámica ---
        SizedBox(height: 300, child: BarChart(_buildBarChartData())),
      ],
    );
  }

  // --- 5. FUNCIÓN "DECISORA" PRINCIPAL ---
  BarChartData _buildBarChartData() {
    List<double> data;
    Widget Function(double, TitleMeta) getTitles;

    // Obtenemos el índice del Set
    int selectedIndex = _filterSelection.first;

    switch (selectedIndex) {
      case 0: // Semana
        data = _fakeWeeklyData;
        getTitles = _getWeeklyTitles;
        break;
      case 1: // Mes
        data = _fakeMonthlyData;
        getTitles = _getMonthlyTitles;
        break;
      case 2: // 3 Meses
        data = _fakeQuarterlyData;
        getTitles = _getQuarterlyTitles;
        break;
      default:
        data = [];
        getTitles = _getWeeklyTitles;
    }

    // --- 2. LÓGICA PARA EJE Y DINÁMICO ---
    double maxY;
    if (data.isEmpty) {
      maxY = 2.0;
    } else {
      double maxDataValue = data.reduce(
        (curr, next) => curr > next ? curr : next,
      );
      maxY = max(maxDataValue.ceil().toDouble(), 2.0);
    }

    return _buildChart(
      data: data,
      getTitles: getTitles,
      maxY: maxY,
      yLabel: 'L',
    );
  }

  // --- 6. Plantilla Genérica para construir la Gráfica ---
  BarChartData _buildChart({
    required List<double> data,
    required Widget Function(double, TitleMeta) getTitles,
    required double maxY,
    required String yLabel,
  }) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1.0,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const SizedBox();
              return Text('${value.toInt()} $yLabel');
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey[200]!, strokeWidth: 1),
      ),
      barGroups: List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data[index],
              color: Theme.of(context).colorScheme.primary,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- 7. Funciones Auxiliares para los Títulos del Eje X ---
  Widget _getWeeklyTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Lun', style: style);
        break;
      case 1:
        text = const Text('Mar', style: style);
        break;
      case 2:
        text = const Text('Mié', style: style);
        break;
      case 3:
        text = const Text('Jue', style: style);
        break;
      case 4:
        text = const Text('Vie', style: style);
        break;
      case 5:
        text = const Text('Sáb', style: style);
        break;
      case 6:
        text = const Text('Dom', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget _getMonthlyTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('S1', style: style);
        break;
      case 1:
        text = const Text('S2', style: style);
        break;
      case 2:
        text = const Text('S3', style: style);
        break;
      case 3:
        text = const Text('S4', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget _getQuarterlyTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Ago', style: style);
        break;
      case 1:
        text = const Text('Sep', style: style);
        break;
      case 2:
        text = const Text('Oct', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
