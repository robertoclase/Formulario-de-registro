import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : null,
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, name, phone, createdAt, updatedAt);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phone: $phone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}