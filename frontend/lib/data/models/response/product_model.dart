import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/models/response/unit_model.dart';

class ProductModel {
  final int id;
  final CategoryModel category;
  final String sku;
  final String name;
  final double price;
  final int stock;
  final UnitModel unit;
  final String image;
  final String? description;

  ProductModel({
    required this.id,
    required this.category,
    required this.sku,
    required this.name,
    required this.price,
    required this.stock,
    required this.unit,
    required this.image,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json){
  // debugPrint('FROM JSON: $json');
  // debugPrint('price runtimeType: ${json['price'].runtimeType}');
  // debugPrint('sku runtimeType: ${json['sku']?.runtimeType}');
  // debugPrint('name runtimeType: ${json['name'].runtimeType}');
  // debugPrint('id runtimeType: ${json['id']?.runtimeType}');
  // debugPrint('stock runtimeType: ${json['stock'].runtimeType}');
  // debugPrint('image runtimeType: ${json['image']?.runtimeType}');

    return ProductModel(
      id: json['id'],
      category: CategoryModel.fromJson(json['category']),
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0 ,
      unit: UnitModel.fromJson(json['unit']),
      image: json['image_url'] ?? 'default',
      description: json['description'] ?? ''
    );
  }
}
