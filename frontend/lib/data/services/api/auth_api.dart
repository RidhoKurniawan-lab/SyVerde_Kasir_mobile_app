import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';

class AuthApi {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(AppEndpoint.login),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        },
      body: jsonEncode({
        'email': email, 
        'password': password
        }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) throw Exception(data['message'] ?? 'Login failed');

    return data;
  }
}