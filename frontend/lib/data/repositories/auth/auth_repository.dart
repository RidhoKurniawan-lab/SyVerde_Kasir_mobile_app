import 'dart:ffi';

import 'package:frontend/data/services/api/auth_api.dart';
import 'package:frontend/core/services/secure_storage.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<void> login(
    String email,
    String password,
  ) async {
    final response = await api.login(
      email: email, 
      password: password
      );
    final token = response['token'];

    // save token securely
    await SecureStorage.saveToken(token);
  }

  // Logout
  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }

  // Check if token exists
  Future<bool> hasToken() async {
    final token = await SecureStorage.getToken();
    return token != null;
  }

}