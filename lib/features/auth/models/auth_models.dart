import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromMap(Map<String, dynamic> map) {
    return LoginRequest(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  factory LoginRequest.fromJson(String source) => 
      LoginRequest.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());

  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(email, password);

  @override
  String toString() => 'LoginRequest(email: $email, password: ****)';
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String? phone;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  factory RegisterRequest.fromMap(Map<String, dynamic> map) {
    return RegisterRequest(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
    );
  }

  factory RegisterRequest.fromJson(String source) => 
      RegisterRequest.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    };
  }

  String toJson() => json.encode(toMap());

  RegisterRequest copyWith({
    String? email,
    String? password,
    String? name,
    String? phone,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterRequest &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.phone == phone;
  }

  @override
  int get hashCode => Object.hash(email, password, name, phone);

  @override
  String toString() => 'RegisterRequest(email: $email, password: ****, name: $name, phone: $phone)';
}