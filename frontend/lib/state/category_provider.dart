import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/repositories/category_repository.dart';
import 'package:frontend/data/services/api/category_api.dart';


// DESPENDENCY

final categoryApiProvider = Provider<CategoryApi>((ref) => CategoryApi());

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) => 
  CategoryRepository(ref.read(categoryApiProvider))
);


// STATE

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}


// NOTIFIER
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
    final repo = ref.read(categoryRepositoryProvider);
    return CategoryNotifier(repo)..fetchCategory();
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository repository;

  CategoryNotifier(this.repository): super(CategoryInitial());

  Future<void> fetchCategory() async {
    state = CategoryLoading();

    try {
      final category = await repository.getCategory();
      state = CategoryLoaded(category);
    } catch (e) {
      state = CategoryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}