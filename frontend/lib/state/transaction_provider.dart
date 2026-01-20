// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/services/api/transaction_api.dart';
import 'package:frontend/data/repositories/transaction_repository.dart';
import 'package:flutter/foundation.dart';

//DESPENDENCY

final transactionApiProvider = Provider<TransactionApi>(
  (ref) => TransactionApi(),
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.read(transactionApiProvider)),
);

// STATE SINGEL GET

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final TransactionModel transaction;
  TransactionLoaded(this.transaction);
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

// STATE QUERY GET

abstract class TransactionQueryState {}

class TransactionQueryInitial extends TransactionQueryState {}

class TransactionQueryLoading extends TransactionQueryState {}

class TransactionQueryLoaded extends TransactionQueryState {
  final List<TransactionModel> transactions;
  TransactionQueryLoaded(this.transactions);
}

// PROVIDER GET
final transactionProvider =
    StateNotifierProvider.autoDispose<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(ref.read(transactionRepositoryProvider)),
    );

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository repository;

  TransactionNotifier(this.repository) : super(TransactionInitial());

  Future<void> getTransactionById({required int id}) async {
    state = TransactionLoading();

    try {
      final transaction = await repository.getTransactionById(id: id);
      debugPrint('Data : $transaction');
      state = TransactionLoaded(transaction);
    } catch (e) {
      debugPrint('ERROR GET TRANSACTION BY ID');
      debugPrint(e.toString());
      state = TransactionError(e.toString());
      state = TransactionError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}

class TransactionQueryError extends TransactionQueryState {
  final String message;
  TransactionQueryError(this.message);
} // PROVIDER GETS

final transactionQueryProvider =
    StateNotifierProvider<TransactionQueryNotifier, TransactionQueryState>(
      (ref) =>
          TransactionQueryNotifier(ref.read(transactionRepositoryProvider)),
    );

// NOTIFIER GETS
class TransactionQueryNotifier extends StateNotifier<TransactionQueryState> {
  final TransactionRepository repository;

  TransactionQueryNotifier(this.repository) : super(TransactionQueryInitial());

  Future<void> getTransaction() async {
    state = TransactionQueryLoading();

    try {
      final transactions = await repository.getTransaction();
      state = TransactionQueryLoaded(transactions);
    } catch (e) {
      state = TransactionQueryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}
