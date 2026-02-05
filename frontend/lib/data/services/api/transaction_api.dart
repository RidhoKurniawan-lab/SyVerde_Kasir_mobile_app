import 'dart:convert';
import 'package:frontend/core/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';

class TransactionApi {
    Future<Map<String, dynamic>> getTransaction({required int page, int? limit}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.transactionGet(page, limit)),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return data;
  }

  Future<Map<String, dynamic>> getTransactionById({required int id}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.transactionGetByid(id)),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');
    if (response.statusCode == 404) throw Exception('Data not found');

    final data = jsonDecode(response.body);
    return data;
  }
  Future<Map<String, dynamic>> getTransactionSummary() async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.transactionSummey),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');
    if (response.statusCode == 404) throw Exception('Data not found');

    final data = jsonDecode(response.body);
    return data;
  }
}