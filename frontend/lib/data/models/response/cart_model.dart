
class CartModel {
  final int productId;
  final String name;
  final double price;
  int qty;

  CartModel({
    required this.productId,
    required this.name,
    required this.price,
    this.qty = 1
  });

  double get subtotal => price * qty;

  CartModel copyWith({int? qty}) {
    return CartModel(
      productId: productId,
      name: name,
      price: price,
      qty: qty ?? this.qty,
    );
  }
}