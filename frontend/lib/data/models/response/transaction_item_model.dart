import 'package:frontend/data/models/response/product_model.dart';

class TransactionItemModel {
  final int productId;
  final int qty;
  final double price;
  final double discount;
  final double subtotal;
  final ProductModel? product;

  const TransactionItemModel({
    required this.productId,
    required this.qty,
    required this.price,
    required this.discount,
    required this.subtotal,
    this.product,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      productId: json['product_id'],
      qty: json['qty'],
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      product: json['product'] != null ? ProductModel.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'qty': qty,
      'price': price,
      'discount': discount,
      'subtotal': subtotal,
    };
  }
}
