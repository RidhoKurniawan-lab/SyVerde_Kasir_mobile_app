class ProductRequest {
  final String name;
  final int categoryId;
  final int unitId;
  final double price;
  final String? sku;
  final String? description;

  ProductRequest({
    required this.name,
    required this.categoryId,
    required this.unitId,
    required this.price,
    this.sku,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category_id': categoryId,
      'unit_id': unitId,
      'price': price,
      'sku': sku,
      'description': description,
    };
  }
}
