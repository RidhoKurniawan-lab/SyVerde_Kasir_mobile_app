import 'package:frontend/core/errors/validation_exception.dart';
import 'package:frontend/data/models/request/product_request_model.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/data/services/api/product_api.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ProductRepository {
  final ProductApi api;

  ProductRepository(this.api);

  Future<Map<String, dynamic>> updateBulkStock({required Map<String, dynamic> payload}) async {
    try {
      final response = await api.updateStockBulk(payload: payload);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

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

  Future<ProductModel> getProductById({required int id}) async {
    try {
      final response = await api.getProductById(id: id);
      return ProductModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> insertProduct({
    required ProductRequest request,
    File? image,
  }) async {
    try {
      final response = await api.insertProduct(
        fields: request.toJson(),
        image: image,
      );
      return ProductModel.fromJson(response);
    } on ValidationException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ProductModel> updateProduct({
    required ProductRequest request,
    File? image,
    required int id,
  }) async {
    try {
      final response = await api.updateProduct(
        fields: request.toJson(),
        image: image,
        id: id,
      );
      return ProductModel.fromJson(response);
    } on ValidationException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteProduct({required int id}) async {
    try {
      final response = await api.deleteProduct(id: id);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
