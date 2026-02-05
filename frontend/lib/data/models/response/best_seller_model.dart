class BestSeller {
  final int productId;
  final String productName;
  final int totalQty;

  BestSeller({
    required this.productId,
    required this.productName,
    required this.totalQty,
  });

  factory BestSeller.fromJson(Map<String, dynamic> json) {
    return BestSeller(
      productId: json['product_id'],
      productName: json['product_name'] ?? '',
      totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
    );
  }
}
