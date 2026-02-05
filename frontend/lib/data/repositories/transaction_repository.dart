import 'package:frontend/data/models/response/pagination_model.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/models/response/summery_model.dart';
import 'package:frontend/data/services/api/transaction_api.dart';
import 'package:flutter/foundation.dart';

class TransactionRepository {
  final TransactionApi api;

  TransactionRepository(this.api);

  Future<PaginatedTransaction> getTransaction({
    required int page,
    int? limit,
    int? userId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await api.getTransaction(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      return PaginatedTransaction.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedStock> getStock({required int page, int? limit}) async {
    try {
      final response = await api.getStock(page: page, limit: limit);

      return PaginatedStock.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedAudit> getAudit({required int page, int? limit}) async {
    try {
      final response = await api.getAudit(page: page, limit: limit);

      return PaginatedAudit.fromJson(response);
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
