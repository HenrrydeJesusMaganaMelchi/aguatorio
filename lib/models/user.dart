// lib/models/user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid; // Cambió de int a String para usar Firebase UID
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phone;
  final String? address;
  final double? weight; // Peso en kg
  final String? activityLevel; // 'poco', 'moderado', 'activo'
  final String? climate; // 'frio', 'templado', 'calido'
  final int? dailyWaterGoal; // Meta diaria en ml
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phone,
    this.address,
    this.weight,
    this.activityLevel,
    this.climate,
    this.dailyWaterGoal,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructor factory para crear un User desde un documento de Firestore
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      phone: json['phone'],
      address: json['address'],
      weight: json['weight']?.toDouble(),
      activityLevel: json['activityLevel'],
      climate: json['climate'],
      dailyWaterGoal: json['dailyWaterGoal'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convertir el User a un Map para guardarlo en Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phone': phone,
      'address': address,
      'weight': weight,
      'activityLevel': activityLevel,
      'climate': climate,
      'dailyWaterGoal': dailyWaterGoal,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Crear una copia del User con algunos campos modificados
  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImageUrl,
    String? phone,
    String? address,
    double? weight,
    String? activityLevel,
    String? climate,
    int? dailyWaterGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      climate: climate ?? this.climate,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
