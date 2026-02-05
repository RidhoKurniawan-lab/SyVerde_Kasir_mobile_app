import 'package:frontend/data/models/response/role_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final RoleModel? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'])
          : null,
    );
  }
}