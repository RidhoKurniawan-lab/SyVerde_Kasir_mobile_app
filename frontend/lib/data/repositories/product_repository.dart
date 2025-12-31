import 'package:frontend/core/errors/validation_exception.dart';
import 'package:frontend/data/models/request/product_request_model.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/data/services/api/product_api.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  final ProductApi api;

  ProductRepository(this.api);

  Future<List<ProductModel>> getProduct() async {
    try {
      final response = await api.getProduct();

      return response
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> insertProduct(ProductRequest request) async {
    try {
      final response = await api.insertProduct(request.toJson());
      return ProductModel.fromJson(response);
    } on ValidationException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
