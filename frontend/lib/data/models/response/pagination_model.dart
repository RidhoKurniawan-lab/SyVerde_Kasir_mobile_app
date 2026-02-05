import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/models/response/audit_model.dart';

class PaginatedTransaction {
  final List<TransactionModel> data;
  final String? nextPageUrl;
  final int currentPage;

  PaginatedTransaction({
    required this.data,
    required this.nextPageUrl,
    required this.currentPage,
  });

  factory PaginatedTransaction.fromJson(Map<String, dynamic> json) {
    return PaginatedTransaction(
      data: (json['data'] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url'],
      currentPage: json['current_page'],
    );
  }
}
class PaginatedStock {
  final List<ProductModel> data;
  final String? nextPageUrl;
  final int currentPage;

  PaginatedStock({
    required this.data,
    required this.nextPageUrl,
    required this.currentPage,
  });

  factory PaginatedStock.fromJson(Map<String, dynamic> json) {
    return PaginatedStock(
      data: (json['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url'],
      currentPage: json['current_page'],
    );
  }
}
class PaginatedAudit {
  final List<AuditModel> data;
  final String? nextPageUrl;
  final int currentPage;

  PaginatedAudit({
    required this.data,
    required this.nextPageUrl,
    required this.currentPage,
  });

  factory PaginatedAudit.fromJson(Map<String, dynamic> json) {
    return PaginatedAudit(
      data: (json['data'] as List)
          .map((e) => AuditModel.fromJson(e))
          .toList(),
      nextPageUrl: json['next_page_url'],
      currentPage: json['current_page'],
    );
  }
}
