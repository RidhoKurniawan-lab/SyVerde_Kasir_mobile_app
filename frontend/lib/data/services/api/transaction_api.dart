import 'dart:convert';
import 'package:frontend/core/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/app_endpoint.dart';

class TransactionApi {
  Future<Map<String, dynamic>> getTransaction({
    required int page,
    int? limit,
    int? userId,
    String? startDate,
    String? endDate,
    String? query,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.transactionGet(page, limit, startDate, endDate, userId, query: query)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
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
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');
    if (response.statusCode == 404) throw Exception('Data not found');

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> cancelTransaction({required int id}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.post(
      Uri.parse(AppEndpoint.transactionCancel(id)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'failed to cancel transaction');
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getTransactionSummary({String period = 'today', int? userId}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final url = userId != null 
        ? "${AppEndpoint.transactionSummey}?period=$period&user_id=$userId"
        : "${AppEndpoint.transactionSummey}?period=$period";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');
    if (response.statusCode == 404) throw Exception('Data not found');

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getStock({
    required int page,
    int? limit,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.stockGet(page, limit)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return data;
  }

  Future<Map<String, dynamic>> getAudit({
    required int page,
    int? limit,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.auditGet(page, limit)),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return data;
  }

  Future<Map<String, dynamic>> getMonthlySummary() async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse(AppEndpoint.transactionMonthlySummary),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getTransactionSummaryByCashier(int cashierId, {String period = 'today'}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse("${AppEndpoint.transactionSummaryByCashier}?cashier_id=$cashierId&period=$period"),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getBestSeller({String period = 'today'}) async {
    final token = await SecureStorage.getToken();

    if (token == null) throw Exception('token expired');

    final response = await http.get(
      Uri.parse("${AppEndpoint.productBestSeller}?period=$period"),
      headers: {
        'Accept': 'application/json', 
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',},
    );
    if (response.statusCode != 200) throw Exception('failed to load data');

    final data = jsonDecode(response.body);
    return data;
  }
}
