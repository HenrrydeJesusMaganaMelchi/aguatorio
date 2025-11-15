// lib/models/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? profileImageUrl; // El '?' significa que puede ser nulo (null)
  final String? phone;
  final String? address;

  // Este es el constructor de la clase
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phone,
    this.address,
  });

  /* Este es el "constructor factory". 
   Su único trabajo es recibir un mapa (JSON) y crear un 
   objeto 'User' a partir de él. Es el "traductor" de JSON a Dart.
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}
