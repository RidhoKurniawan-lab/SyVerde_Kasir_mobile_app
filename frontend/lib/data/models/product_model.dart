import 'package:frontend/data/models/category_model.dart';

class ProductModel {
  final int id;
  final CategoryModel category;
  final String sku;
  final String name;
  final String price;
  final int stock;
  final String unit;
  final String image;

  ProductModel({
    required this.id,
    required this.category,
    required this.sku,
    required this.name,
    required this.price,
    required this.stock,
    required this.unit,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      id: json['id'],
      category: CategoryModel.fromJson(json['category']),
      sku: json['sku'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      unit: json['unit'],
      image: json['image']
    );
  }
}
