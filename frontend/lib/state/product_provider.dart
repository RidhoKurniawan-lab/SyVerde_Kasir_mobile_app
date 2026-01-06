// import 'package:flutter/widgets.dart';
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

// STATE GET

abstract class ProductQueryState {}

class ProductQueryInitial extends ProductQueryState {}

class ProductQueryLoading extends ProductQueryState {}

class ProductQueryLoaded extends ProductQueryState {
  final List<ProductModel> products;
  ProductQueryLoaded(this.products);
}

class ProductQueryError extends ProductQueryState {
  final String message;
  ProductQueryError(this.message);
}

// 
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductModel product;
  ProductLoaded(this.product);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// STATE SUBMIT

abstract class ProductSubmitState {}

class ProductSubmitInitial extends ProductSubmitState {}

class ProductSubmitLoading extends ProductSubmitState {}

class ProductSubmitSuccess extends ProductSubmitState {}

class ProductSubmitError extends ProductSubmitState {
  final String message;
  ProductSubmitError(this.message);
}

class ProductSubmitValidationError extends ProductSubmitState {
  final Map<String, List<String>> errors;
  ProductSubmitValidationError(this.errors);
}

// PROVIDER GET
final productProvider = 
StateNotifierProvider<ProductNotifier, ProductState>((ref) => ProductNotifier(ref.read(productRepositoryProvider)),);

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductNotifier(this.repository) : super(ProductInitial());

  Future<void> getProductById({required int id}) async {
    state = ProductLoading();

    try {
      final product = await repository.getProductById(id: id);
      state = ProductLoaded(product);
    } catch (e) {
      state = ProductError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}

// PROVIDER GETS
final productQueryProvider =
    StateNotifierProvider<ProductQueryNotifier, ProductQueryState>(
      (ref) => ProductQueryNotifier(ref.read(productRepositoryProvider)),
    );

// NOTIFIER GETS
class ProductQueryNotifier extends StateNotifier<ProductQueryState> {
  final ProductRepository repository;

  ProductQueryNotifier(this.repository) : super(ProductQueryInitial());

  Future<void> getProduct() async {
    state = ProductQueryLoading();

    try {
      final products = await repository.getProduct();
      state = ProductQueryLoaded(products);
    } catch (e) {
      state = ProductQueryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}

final productSubmitProvider =
    StateNotifierProvider<ProductSubmitNotifier, ProductSubmitState>(
      (ref) => ProductSubmitNotifier(ref.read(productRepositoryProvider)),
    );

class ProductSubmitNotifier extends StateNotifier<ProductSubmitState> {
  final ProductRepository repository;

  ProductSubmitNotifier(this.repository) : super(ProductSubmitInitial());

  Future<void> insertProduct({
    required ProductRequest request,
    File? image,
  }) async {
    state = ProductSubmitLoading();

    try {
      await repository.insertProduct(request: request, image: image);

      state = ProductSubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = ProductSubmitValidationError(e.errors);
      } else {
        state = ProductSubmitError(e.toString());
      }
    }
  }

  Future<void> updateProduct({
    required ProductRequest request,
    File? image,
    required int id
  }) async {
    state = ProductSubmitLoading();

    try {
      await repository.updateProduct(request: request, image: image, id: id);
      state = ProductSubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = ProductSubmitValidationError(e.errors);
      } else {
        state = ProductSubmitError(e.toString());
      }
    }
  }

  Future<void> deleteProduct({
    required int id
  }) async {
    state = ProductSubmitLoading();

    try {
      await repository.deleteProduct(id: id);
      state = ProductSubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = ProductSubmitValidationError(e.errors);
      } else {
        state = ProductSubmitError(e.toString());
      }
    }
  }
}
