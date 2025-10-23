// lib/models/app_user.dart
import 'dart:convert';

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String token;
  final String password;

  AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'token': token,
      'password': password,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['_id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      token: map['token'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
