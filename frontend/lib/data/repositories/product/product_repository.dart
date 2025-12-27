
import 'package:frontend/data/models/product_model.dart';
import 'package:frontend/data/services/api/product_api.dart';

class ProductRepository {
  final ProductApi api;

  ProductRepository(this.api);

  Future<List<ProductModel>> getProduct() async {
    try{
      final response = await api.getProducts();

      return response.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
    }catch (e) {
      rethrow;
    }
  }
}