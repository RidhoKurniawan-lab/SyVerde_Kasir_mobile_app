class StockUpdateItem {
  final int productId;
  final String name;
  final int change;

  const StockUpdateItem({
    required this.productId,
    required this.name,
    required this.change,
  });

  StockUpdateItem copyWith({int? change, int? productId,}) {
    return StockUpdateItem(
      productId: productId ?? this.productId,
      name: name,
      change: change ?? this.change,
    );
  }
}
