import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>((ref) => CartNotifier(),);

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  void addItem({
    required int productId,
    required String name,
    required double price,
  }) {
    final index = state.indexWhere((e) => e.productId == productId);

    if (index >= 0) {
      state[index].qty += 1;
      state = [...state];
    } else {
      state = [
        ...state,
        CartModel(
          productId: productId,
          name: name,
          price: price,
        ),
      ];
    }
  }

  // ➕ tambah qty
  void increaseQty(int productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(qty: item.qty + 1);
      }
      return item;
    }).toList();
  }

  // ➖ kurang qty
  void decreaseQty(int productId) {
    state = state
        .map((item) {
          if (item.productId == productId) {
            return item.copyWith(qty: item.qty - 1);
          }
          return item;
        })
        .where((item) => item.qty > 0) 
        .toList();
  }

  void removeItem(int productId) {
    state = state
        .where((e) => e.productId != productId)
        .toList();
  }

  void clear() {
    state = [];
  }

  int get totalQty => state.fold(0, (sum, item) => sum + item.qty);

  double get total =>
      state.fold(0, (sum, item) => sum + item.subtotal);

}