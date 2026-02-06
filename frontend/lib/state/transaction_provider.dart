// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/audit_model.dart';
import 'package:frontend/data/models/response/summery_model.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/data/models/response/monthly_summary_model.dart';
import 'package:frontend/data/models/response/best_seller_model.dart';
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

class TransactionLoadedSummery extends TransactionState {
  final TransactionSummary summery;
  TransactionLoadedSummery(this.summery);
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

// STATE QUERY GET

abstract class TransactionQueryState {}

class TransactionQueryInitial extends TransactionQueryState {}

class TransactionQueryLoading extends TransactionQueryState {
  final int? currentPage;
  TransactionQueryLoading(this.currentPage);
}

abstract class StockQueryState {}

class StockQueryInitial extends StockQueryState {}

class StockQueryLoading extends StockQueryState {
  final int? currentPage;
  StockQueryLoading(this.currentPage);
}

class TransactionQueryLoaded extends TransactionQueryState {
  final List<TransactionModel> transactions;
  final int? currentPage;
  final bool isLastPage;
  TransactionQueryLoaded({
    required this.transactions,
    required this.currentPage,
    required this.isLastPage,
  });
}

class StockQueryLoaded extends StockQueryState {
  final List<ProductModel> stocks;
  final int? currentPage;
  final bool isLastPage;
  StockQueryLoaded({
    required this.stocks,
    required this.currentPage,
    required this.isLastPage,
  });
}

abstract class AuditQueryState {}

class AuditQueryInitial extends AuditQueryState {}

class AuditQueryLoading extends AuditQueryState {
  final int? currentPage;
  AuditQueryLoading(this.currentPage);
}

class AuditQueryLoaded extends AuditQueryState {
  final List<AuditModel> audits;
  final int? currentPage;
  final bool isLastPage;
  AuditQueryLoaded({
    required this.audits,
    required this.currentPage,
    required this.isLastPage,
  });
}

class AuditQueryError extends AuditQueryState {
  final String message;
  AuditQueryError(this.message);
}

// PROVIDER GET
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
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
      state = TransactionError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }

  Future<void> getTransactionSummary({String period = 'today', bool silent = false, int? userId}) async {
    if (!silent) {
      state = TransactionLoading();
    }

    try {
      final summery = await repository.getTransactionSummery(period: period, userId: userId);
      debugPrint('Data $summery');
      state = TransactionLoadedSummery(summery);
    } catch (e, stack) {
      debugPrint('ERROR getTransactionSummary: $e');
      debugPrintStack(stackTrace: stack);

      state = TransactionError(e.toString());
    }
  }

  Future<void> cancelTransaction({required int id}) async {
    state = TransactionLoading();

    try {
      final transaction = await repository.cancelTransaction(id: id);
      state = TransactionLoaded(transaction);
    } catch (e) {
      state = TransactionError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }

  void reset() {
    state = TransactionInitial();
  }
}

final transactionSummaryByCashierProvider =
    StateNotifierProvider<TransactionSummaryByCashierNotifier, TransactionState>(
  (ref) => TransactionSummaryByCashierNotifier(ref.read(transactionRepositoryProvider)),
);

class TransactionSummaryByCashierNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository repository;

  TransactionSummaryByCashierNotifier(this.repository) : super(TransactionInitial());

  Future<void> getTransactionSummaryByCashier(int cashierId, {String period = 'today'}) async {
    state = TransactionLoading();

    try {
      final summery = await repository.getTransactionSummeryByCashier(cashierId, period: period);
      state = TransactionLoadedSummery(summery);
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }

  void reset() {
    state = TransactionInitial();
  }
}

final monthlyTransactionProvider = FutureProvider.autoDispose<List<MonthlySummary>>((ref) async {
  return ref.read(transactionRepositoryProvider).getMonthlySummary();
});

abstract class BestSellerState {}

class BestSellerInitial extends BestSellerState {}

class BestSellerLoading extends BestSellerState {}

class BestSellerLoaded extends BestSellerState {
  final List<BestSeller> products;
  BestSellerLoaded(this.products);
}

class BestSellerError extends BestSellerState {
  final String message;
  BestSellerError(this.message);
}

final bestSellerProductProvider =
    StateNotifierProvider<BestSellerNotifier, BestSellerState>(
  (ref) => BestSellerNotifier(ref.read(transactionRepositoryProvider)),
);

class BestSellerNotifier extends StateNotifier<BestSellerState> {
  final TransactionRepository repository;

  BestSellerNotifier(this.repository) : super(BestSellerInitial());

  Future<void> getBestSeller({String period = 'today'}) async {
    state = BestSellerLoading();

    try {
      final products = await repository.getBestSeller(period: period);
      state = BestSellerLoaded(products);
    } catch (e) {
      state = BestSellerError(e.toString());
    }
  }

  void reset() {
    state = BestSellerInitial();
  }
}

class TransactionQueryError extends TransactionQueryState {
  final String message;
  TransactionQueryError(this.message);
} // PROVIDER GETS

class StockQueryError extends StockQueryState {
  final String message;
  StockQueryError(this.message);
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

  Future<void> getTransaction({
    int page = 1,
    int limit = 20,
    int? userId = 0,
    String? startDate = '',
    String? endDate = '',
    String? query = '',
  }) async {
    state = TransactionQueryLoading(page);

    try {
      final transactions = await repository.getTransaction(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        userId: userId,
        query: query,
      );
      state = TransactionQueryLoaded(
        transactions: transactions.data,
        currentPage: page,
        isLastPage: transactions.nextPageUrl == null,
      );
    } catch (e) {
      state = TransactionQueryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }

  void reset() {
    state = TransactionQueryInitial();
  }
}

final transactionSearchProvider =
    StateNotifierProvider<TransactionQueryNotifier, TransactionQueryState>(
      (ref) =>
          TransactionQueryNotifier(ref.read(transactionRepositoryProvider)),
    );

final stockQueryProvider =
    StateNotifierProvider<StockQueryNotifier, StockQueryState>(
      (ref) => StockQueryNotifier(ref.read(transactionRepositoryProvider)),
    );

// NOTIFIER GETS
class StockQueryNotifier extends StateNotifier<StockQueryState> {
  final TransactionRepository repository;

  StockQueryNotifier(this.repository) : super(StockQueryInitial());

  Future<void> getStock({int page = 1, int limit = 20}) async {
    state = StockQueryLoading(page);

    try {
      final stock = await repository.getStock(page: page, limit: limit);
      state = StockQueryLoaded(
        stocks: stock.data,
        currentPage: page,
        isLastPage: stock.nextPageUrl == null,
      );
    } catch (e) {
      state = StockQueryError(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  void reset() {
    state = StockQueryInitial();
  }
}

final auditQueryProvider =
    StateNotifierProvider<AuditQueryNotifier, AuditQueryState>(
      (ref) => AuditQueryNotifier(ref.read(transactionRepositoryProvider)),
    );

// NOTIFIER GETS
class AuditQueryNotifier extends StateNotifier<AuditQueryState> {
  final TransactionRepository repository;

  AuditQueryNotifier(this.repository) : super(AuditQueryInitial());

  Future<void> getAudit({int page = 1, int limit = 20}) async {
    state = AuditQueryLoading(page);

    try {
      final audit = await repository.getAudit(page: page, limit: limit);
      state = AuditQueryLoaded(
        audits: audit.data,
        currentPage: page,
        isLastPage: audit.nextPageUrl == null,
      );
    } catch (e) {
      state = AuditQueryError(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  void reset() {
    state = AuditQueryInitial();
  }
}
