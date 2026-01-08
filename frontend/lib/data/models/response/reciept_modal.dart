class StockUpdateItem {
  final int id;
  final String name;
  final int stock;

  const StockUpdateItem({
    required this.id,
    required this.name,
    required this.stock,
  });

  StockUpdateItem copyWith({int? stock, int? id,}) {
    return StockUpdateItem(
      id: id ?? this.id,
      name: name,
      stock: stock ?? this.stock,
    );
  }
}
