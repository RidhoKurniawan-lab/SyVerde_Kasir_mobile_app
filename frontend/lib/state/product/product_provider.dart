import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/services/api/product_api.dart';
import 'package:frontend/data/repositories/product/product_repository.dart';
import 'package:frontend/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

//DESPENDENCY

final productApiProvider = Provider<ProductApi>((ref){
  return ProductApi();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.read(productApiProvider));
});

// STATE

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// NOTIFIER

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return ProductNotifier(repo)..fetchProduct();
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductNotifier(this.repository) : super(ProductInitial());

  Future<void> fetchProduct() async {
    state = ProductLoading();
    
    try{
      final products = await repository.getProduct();

      state = ProductLoaded(products);
    }catch(e) {
      state = ProductError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }

  }

}