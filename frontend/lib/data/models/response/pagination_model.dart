import 'package:frontend/data/models/response/transaction_model.dart';

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
