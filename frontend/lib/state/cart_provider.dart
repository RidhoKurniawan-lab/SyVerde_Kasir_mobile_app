import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/cart_model.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/data/models/response/transaction_model.dart';



final cartFormProvider =
    StateNotifierProvider<CheckoutFormNotifier, CheckoutForm>(
  (ref) => CheckoutFormNotifier(),
);

class CheckoutFormNotifier extends StateNotifier<CheckoutForm> {
  CheckoutFormNotifier() : super(const CheckoutForm());

  void setPaymentMethod(String value) {
    state = state.copyWith(paymentMethod: value);
  }

  void setPaidAmount(double value) {
    state = state.copyWith(paidAmount: value);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>((ref) => CartNotifier(),);
class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);
  final discount = 0;

  void addItem({
    required int productId,
    required String name,
    required double price,
  }) {
    final index = state.indexWhere((e) => e.productId == productId);

    if (index >= 0) {
      state[index].qty += 1;
      state = [...state];
      debugPrint('UPDATE QTY → ${state[index].name} = ${state[index].qty}');
    } else {
      state = [
        ...state,
        CartModel(
          productId: productId,
          name: name,
          price: price,
        ),
      ];
      debugPrint('ADD ITEM → $name');
    }
    _logCart();
  }

  void _logCart() {
    debugPrint('------ CART STATE ------');
    for (final item in state) {
      debugPrint(
        '${item.name} | qty=${item.qty} | price=${item.price} | subtotal=${item.subtotal}',
      );
    }
    debugPrint('TOTAL = $total');
    debugPrint('------------------------');
  }

  Map<String, dynamic> buildPayload(String payment, double paid, double discountTotal){
    return {
    'payment_method': payment,
    'paid_amount': paid,
    'total': total,
    'discount_total': discount,
    'grand_total': total - discount,
    'change_amount': paid - (total - discount),
    'items': state.map((item) => {
      'product_id': item.productId,
      'qty': item.qty,
      'price': item.price,
      'discount': 0,
      'subtotal': item.subtotal
    }).toList(),  
  };
  }

  // increment qty
  void increaseQty(int productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(qty: item.qty + 1);
      }
      return item;
    }).toList();
  }

  // decrement qty
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