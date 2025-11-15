// lib/models/water_log.dart

class WaterLog {
  final int id;
  final int userId;
  final int amountMl; // La cantidad de agua en mililitros
  final DateTime timestamp; // La hora exacta del registro
  final int? activityId; // El ID de la actividad (opcional)

  WaterLog({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    this.activityId, // Es opcional, por eso no lleva 'required'
  });

  /*
  Este factory es un poco diferente porque incluye un 'DateTime'.
  Tu API de Laravel enviará la fecha en un formato de texto estándar (ISO 8601),
  algo como: "2025-11-05T17:30:00Z".
  
  DateTime.parse() es la función de Dart que sabe cómo "leer" ese
  texto y convertirlo en un objeto DateTime real.
  */
  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'],
      userId: json['user_id'],
      amountMl: json['amount_ml'],
      timestamp: DateTime.parse(json['timestamp']), // Conversión clave
      activityId: json['activity_id'],
    );
  }
}
