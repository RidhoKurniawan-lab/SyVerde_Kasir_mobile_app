import 'package:frontend/data/models/response/user_model.dart';

class AuditModel {
  final int? id;
  // final UserModel? user;
  final String? action;
  final String? description;
  final int? entryableId;
  final String? entryableType;
  final DateTime? createdAt;
  final String? username;


  AuditModel({
    this.id,
    // this.user,
    this.action = '',
    this.description = '',
    this.entryableId = 0,
    this.entryableType = '',
    this.createdAt,
    this.username
  });

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      id: json['id'],
      entryableId: json['entryable_id'],
      // user: json['user_id'] != null
      //     ? UserModel.fromJson(json['category'])
      //     : null,
      action: json['action'] ?? '',
      username: json['user_name'] ?? '',
      description: json['description'] ?? '',
      entryableType: json['entryable_type'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
