import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';
import 'package:frontend/core/services/secure_storage.dart';


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
        'ngrok-skip-browser-warning': 'true',
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

    Future<List<dynamic>> getUser() async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.userGet),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
        },
    );

    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body) as List;

    return data;
  }
}