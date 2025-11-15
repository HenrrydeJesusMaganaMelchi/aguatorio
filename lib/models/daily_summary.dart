// lib/models/daily_summary.dart

class DailySummary {
  final DateTime date;
  final int totalConsumedMl;
  final int goalMl;

  // Este es un mapa donde la llave es la hora (ej: "08:00")
  // y el valor es la cantidad (ej: 500).
  final Map<String, int> hourlyBreakdown;

  DailySummary({
    required this.date,
    required this.totalConsumedMl,
    required this.goalMl,
    required this.hourlyBreakdown,
  });

  /*
  Este factory tiene dos conversiones importantes:
  1. Convierte el texto 'date' en un objeto DateTime.
  2. Convierte el objeto JSON 'hourly_breakdown' en un 
     Map<String, int> de Dart.
  
  Usamos 'Map.from(json['hourly_breakdown']).map(...)'
  para asegurar que los tipos sean correctos (String, int)
  y Dart pueda usarlos para construir la gráfica.
  */
  factory DailySummary.fromJson(Map<String, dynamic> json) {
    // Convertimos el mapa genérico (Map<String, dynamic>)
    // a un mapa tipado (Map<String, int>)
    final hourlyMap = Map<String, int>.from(
      Map.from(
        json['hourly_breakdown'],
      ).map((key, value) => MapEntry(key, value as int)),
    );

    return DailySummary(
      date: DateTime.parse(json['date']),
      totalConsumedMl: json['total_consumed_ml'],
      goalMl: json['goal_ml'],
      hourlyBreakdown: hourlyMap,
    );
  }
}
