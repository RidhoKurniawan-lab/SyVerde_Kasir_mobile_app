import 'package:frontend/data/models/response/pagination_model.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/models/response/summery_model.dart';
import 'package:frontend/data/services/api/transaction_api.dart';
import 'package:flutter/foundation.dart';

class TransactionRepository {
  final TransactionApi api;

  TransactionRepository(this.api);

  Future<PaginatedTransaction> getTransaction({required int page, int? limit}) async {
    try {
      final response = await api.getTransaction(page: page, limit: limit);

      return PaginatedTransaction.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> getTransactionById({required int id}) async {
    try {
      final response = await api.getTransactionById(id: id);
      return TransactionModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<TransactionSummary> getTransactionSummery() async {
    try {
      final response = await api.getTransactionSummary();
      debugPrint('Data $response');
      return TransactionSummary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
