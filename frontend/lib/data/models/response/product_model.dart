import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/models/response/unit_model.dart';

class ProductModel {
  final int? id;
  final CategoryModel? category;
  final String sku;
  final String name;
  final double price;
  final int stock;
  final UnitModel? unit;
  final String image;
  final String? description;

  ProductModel({
    this.id,
    this.category,
    this.sku = '',
    this.name = '',
    this.price = 0,
    this.stock = 0,
    this.unit,
    this.image = '',
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      unit: json['unit'] != null
          ? UnitModel.fromJson(json['unit'])
          : null,
      image: json['image_url'] ?? '',
      description: json['description'],
    );
  }
}
