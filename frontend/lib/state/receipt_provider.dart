import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/reciept_modal.dart';

final receiptProvider = StateNotifierProvider<ReceiptNotifier, List<StockUpdateItem>>((ref) => ReceiptNotifier(),);

class ReceiptNotifier extends StateNotifier<List<StockUpdateItem>> {
  ReceiptNotifier() : super([]);


   Future<void> addProduct({
    required int productId,
    required String name,
  }) async {

    state = [
      ...state,
      StockUpdateItem(
        productId: productId,
        name: name,
        change: 0,
      ),
    ];
  }


  void debugLog() {
    debugPrint('====== STOCK UPDATE STATE ======');

    if (state.isEmpty) {
      debugPrint('EMPTY');
    }

    for (final item in state) {
      debugPrint(
        'id=${item.productId} | '
        '${item.name} | '
        'change=${item.change} | '
      );
    }

    debugPrint('CHANGED ITEMS = ${changedItems.length}');
    debugPrint('===============================');
  }

  void increase(int productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(change: item.change + 1);
      }
      return item;
    }).toList();
  }

  void decrease(int productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(change: item.change - 1);
      }
      return item;
    })
    .where((item) => item.change > 0)
    .toList();
  }

  void remove(int productId) {
    state = state.where((e) => e.productId != productId).toList();
  }

  void reset() {
    state = [];
  }

  List<StockUpdateItem> get changedItems =>
      state.where((e) => e.change != 0).toList();
}
