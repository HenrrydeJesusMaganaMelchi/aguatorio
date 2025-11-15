// lib/models/activity.dart

class Activity {
  final int id;
  final String name;
  final String? iconUrl; // El '?' es por si alguna actividad no tiene ícono

  Activity({required this.id, required this.name, this.iconUrl});

  /*
  Este es el "traductor" de JSON a Dart para una Actividad.
  Tu API de Laravel enviará un JSON como este:
  { "id": 1, "name": "Gimnasio", "icon_url": "..." }
  Y este 'factory' lo convertirá en un objeto 'Activity' en Dart.
  */
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
    );
  }
}
