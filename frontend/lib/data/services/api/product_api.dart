import 'dart:convert';
import 'package:frontend/core/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';
import 'package:frontend/core/errors/validation_exception.dart';
import 'dart:io';

class ProductApi {
  // get all product

  Future<List<dynamic>> getProduct() async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.productGet),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body) as List;

    return data;
  }

  // insert  product

  Future<Map<String, dynamic>> insertProduct({
    required Map<String, dynamic> fields,
    File? image,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(AppEndpoint.productInsert),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    fields.forEach((key, value){
      request.fields[key] = value.toString();
    });

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final data = jsonDecode(response.body);

    if (response.statusCode == 422) throw ValidationException.fromJson(data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Failed to add product');
    }
    return data;
  }
}
