import 'dart:convert';
import 'package:frontend/core/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';

class CategoryApi {
  Future<List<dynamic>> getCategory() async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.category),
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

  Future<Map<String, dynamic>> getCategoryById({
    required int id,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('Token Expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.categoryById(id)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );

    if (response.statusCode == 404) throw Exception(jsonDecode(response.body)['message'] ?? 'Data not found');

    final data = jsonDecode(response.body);

    return data;
  }

  Future<Map<String, dynamic>> insertCategory({
    required Map<String, dynamic> fields
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('Token Expired');

    final response = await http.post(
      Uri.parse(AppEndpoint.categoryInsert),
      headers: {
        'Content-Type': 'application/json', 
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
        },
      body: jsonEncode(fields)
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to add product',
      );
    }

    final data = jsonDecode(response.body);

    return data;
  }

  Future<Map<String, dynamic>> updateCategory({
    required Map<String, dynamic> fields,
    required int id,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('Token Expired');

    final response = await http.put(
      Uri.parse(AppEndpoint.categoryUpdate(id)),
      headers: {
        'Content-Type': 'application/json', 
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
        },
      body: jsonEncode(fields)
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to update product',
      );
    }

    final data = jsonDecode(response.body);

    return data;
  }

  Future<Map<String, dynamic>> deleteCategory({required int id}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('Token Expired');

    final response = await http.delete(
      Uri.parse(AppEndpoint.categoryDelete(id)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
        },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to add product',
      );
    }
    
    return jsonDecode(response.body);
  }
}
