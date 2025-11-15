// lib/models/achievement.dart

class Achievement {
  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final bool isEarned; // Para saber si el usuario ya lo ganó

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.iconUrl,
    required this.isEarned,
  });

  /*
  Este factory maneja una conversión importante:
  Tu API de Laravel (o cualquier API) probablemente enviará
  el 'is_earned' como un 'true' o 'false' (booleano)
  directamente, lo cual Dart maneja sin problemas.
  
  (Si la API enviara un 1 o 0, tendríamos que hacer
  'isEarned: json['is_earned'] == 1', pero asumiremos
  que la API enviará un booleano limpio).
  */
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['icon_url'],
      isEarned: json['is_earned'], // Asume que el JSON envía 'true' o 'false'
    );
  }
}
