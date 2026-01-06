import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/services/api/category_api.dart';
import 'package:frontend/core/errors/validation_exception.dart';
import 'package:flutter/foundation.dart';


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

  Future<CategoryModel> getCategoryById({required int id}) async {
    try {
      final response = await api.getCategoryById(id: id);
      return CategoryModel.fromJson(response);
    } catch (e) {
       rethrow;
    }
  }

  Future<CategoryModel> insertCategory({required CategoryModel request})async{
    try {
      final response = await api.insertCategory(fields: request.toJson());
      return CategoryModel.fromJson(response);
    } on ValidationException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory({required CategoryModel request, required int id})async{
    try {
      final response = await api.updateCategory(fields: request.toJson(), id: id);
      return CategoryModel.fromJson(response);
    } on ValidationException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteCategory({required int id})async{
    try {
      final response = await api.deleteCategory(id: id);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}