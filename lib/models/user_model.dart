// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role; // 'user', 'admin', 'helpdesk'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
