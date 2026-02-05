import 'package:frontend/data/models/response/pagination_model.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/models/response/summery_model.dart';
import 'package:frontend/data/models/response/monthly_summary_model.dart';
import 'package:frontend/data/models/response/best_seller_model.dart';
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
    String? query,
  }) async {
    try {
      final response = await api.getTransaction(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        query: query,
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

  Future<TransactionSummary> getTransactionSummery({String period = 'today'}) async {
    try {
      final response = await api.getTransactionSummary(period: period);
      debugPrint('Data $response');
      return TransactionSummary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionSummary> getTransactionSummeryByCashier(int cashierId, {String period = 'today'}) async {
    try {
      final response = await api.getTransactionSummaryByCashier(cashierId, period: period);
      return TransactionSummary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MonthlySummary>> getMonthlySummary() async {
    try {
      final response = await api.getMonthlySummary();
      final data = response['data'] as List;
      return data.map((json) => MonthlySummary.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BestSeller>> getBestSeller({String period = 'today'}) async {
    try {
      final response = await api.getBestSeller(period: period);
      final data = response['data'] as List;
      return data.map((json) => BestSeller.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
