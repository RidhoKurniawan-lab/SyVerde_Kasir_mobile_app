import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/services/api/category_api.dart';

class CategoryRepository {
  final CategoryApi api;

  CategoryRepository(this.api);

  Future<List<CategoryModel>> getCategory() async {
    try{
      final response = await api.getCategory();

      return response.map<CategoryModel>((json) => CategoryModel.fromJson(json)).toList();
    }catch (e) {
      rethrow;
    }
  }
}