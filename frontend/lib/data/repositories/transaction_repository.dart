import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/services/api/transaction_api.dart';

class TransactionRepository {
  final TransactionApi api;

  TransactionRepository(this.api);

  Future<List<TransactionModel>> getTransaction() async {
    try {
      final response = await api.getTransaction();

      return response
          .map<TransactionModel>((json) => TransactionModel.fromJson(json))
          .toList();
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
}
