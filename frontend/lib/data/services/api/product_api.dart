import 'dart:convert';
import 'package:frontend/core/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';
import 'package:frontend/core/errors/validation_exception.dart';
import 'package:flutter/foundation.dart';

class ProductApi {

  // get all product

  Future<List<dynamic>> getProduct() async {
    final token = await SecureStorage.getToken();

     if (token == null) throw Exception('token expired');

     final response = await http.get(
      Uri.parse(AppEndpoint.productGet),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
     );
     if (response.statusCode != 200) throw Exception('failed to load data');

     final data = jsonDecode(response.body) as List;

     return data;
  }

  // insert  product

  Future<Map<String, dynamic>> insertProduct(Map<String, dynamic> body) async {
    final token = await SecureStorage.getToken();

    if (token == null ) throw Exception('token expired');

    final response = await http.post(
      Uri.parse(AppEndpoint.productInsert),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 422) throw ValidationException.fromJson(data);

    if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(data['message'] ?? 'Failed to add product');
  }
    return data;
  }
}
