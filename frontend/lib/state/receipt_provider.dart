import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/reciept_modal.dart';

final receiptProvider = StateNotifierProvider<ReceiptNotifier, List<StockUpdateItem>>((ref) => ReceiptNotifier(),);

class ReceiptNotifier extends StateNotifier<List<StockUpdateItem>> {
  ReceiptNotifier() : super([]);


   Future<void> addProduct({
    required int id,
    required String name,
  }) async {

    state = [
      ...state,
      StockUpdateItem(
        id: id,
        name: name,
        stock: 0,
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
        'id=${item.id} | '
        '${item.name} | '
        'change=${item.stock} | '
      );
    }

    debugPrint('CHANGED ITEMS = ${changedItems.length}');
    debugPrint('===============================');
  }

  Map<String, dynamic> buildPayload() {
  return {
    'items': state.map((item) => {
      'id': item.id,
      'stock': item.stock,
    }).toList(),  
  };
}


  void increase(int id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(stock: item.stock + 1);
      }
      return item;
    }).toList();
  }

  void decrease(int id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(stock: item.stock - 1);
      }
      return item;
    })
    .where((item) => item.stock > 0)
    .toList();
  }

  void remove(int id) {
    state = state.where((e) => e.id != id).toList();
  }

  void reset() {
    state = [];
  }

  List<StockUpdateItem> get changedItems =>
      state.where((e) => e.stock != 0).toList();
}
