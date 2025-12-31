import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/request/product_request_model.dart';
import 'package:frontend/data/services/api/product_api.dart';
import 'package:frontend/data/repositories/product_repository.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/core/errors/validation_exception.dart';
import 'dart:io';

//DESPENDENCY

final productApiProvider = Provider<ProductApi>((ref) => ProductApi());

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.read(productApiProvider)),
);

// STATE

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductValidationError extends ProductState {
  final Map<String, List<String>> errors;
  ProductValidationError(this.errors);
}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// NOTIFIER

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  final repo = ref.read(productRepositoryProvider);
  return ProductNotifier(repo)..getProduct();
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductNotifier(this.repository) : super(ProductInitial());

  // get product
  Future<void> getProduct() async {
    state = ProductLoading();

    try {
      final products = await repository.getProduct();
      state = ProductLoaded(products);
    } catch (e) {
      debugPrint("$e.toString()");
      state = ProductError(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<void> insertProduct({
    required ProductRequest request,
    File? image,
  }) async {
    final previousState = state; // simpan state sebelumnya,
    state = ProductLoading();

    try {
      final product = await repository.insertProduct(
        request: request,
        image: image,
      );
      if (previousState is ProductLoaded) {
        state = ProductLoaded([
          ...previousState.products,
          product,
        ]); // pakai state sebelumya dan gabungkan dengan yang baru
      }
    } catch (e) {
      if (e is ValidationException) {
        state = ProductValidationError(e.errors);
      } else {
        state = ProductError(e.toString());
      }
    }
  }
}
