import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/category_model.dart';
import 'package:frontend/data/repositories/category_repository.dart';
import 'package:frontend/data/services/api/category_api.dart';
import 'package:frontend/core/errors/validation_exception.dart';

// DESPENDENCY

final categoryApiProvider = Provider<CategoryApi>((ref) => CategoryApi());

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.read(categoryApiProvider)),
);

// STATE SUBMIT

abstract class CategorySubmitState {}

class CategorySubmitInitial extends CategorySubmitState {}

class CategorySubmitLoading extends CategorySubmitState {}

class CategorySubmitSuccess extends CategorySubmitState {}

class CategorySubmitLoaded extends CategorySubmitState {
  final CategoryModel category;
  CategorySubmitLoaded(this.category);
}

class CategorySubmitError extends CategorySubmitState {
  final String message;
  CategorySubmitError(this.message);
}

class CategorySubmitValidationError extends CategorySubmitState {
  final Map<String, List<String>> errors;
  CategorySubmitValidationError(this.errors);
}

// STATE QUERY

abstract class CategoryQueryState {}

class CategoryQueryInitial extends CategoryQueryState {}

class CategoryQueryLoading extends CategoryQueryState {}

class CategoryQueryLoaded extends CategoryQueryState {
  final List<CategoryModel> categories;
  CategoryQueryLoaded(this.categories);
}

class CategoryQueryError extends CategoryQueryState {
  final String message;
  CategoryQueryError(this.message);
}

// STATE Get

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final CategoryModel category;
  CategoryLoaded(this.category);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

// NOTIFIER
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(ref.read(categoryRepositoryProvider)),
);

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository repository;

  CategoryNotifier(this.repository) : super(CategoryInitial());

  Future<CategoryModel> getCategoryById({required int id}) async {
    state = CategoryLoading();

    try {
      final category = await repository.getCategoryById(id: id);
      state = CategoryLoaded(category);
      return category;
    } catch (e) {
      state = CategoryError(e.toString().replaceAll('Exception:', '').trim());
      rethrow;
    }
  }
}

final categoryQueryProvider =
    StateNotifierProvider<CategoryQueryNotifier, CategoryQueryState>(
      (ref) => CategoryQueryNotifier(ref.read(categoryRepositoryProvider)),
    );

class CategoryQueryNotifier extends StateNotifier<CategoryQueryState> {
  final CategoryRepository repository;

  CategoryQueryNotifier(this.repository) : super(CategoryQueryInitial());

  Future<void> getCategory() async {
    state = CategoryQueryLoading();

    try {
      final category = await repository.getCategory();
      state = CategoryQueryLoaded(category);
    } catch (e) {
      state = CategoryQueryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}

final categorySubmitProvider =
    StateNotifierProvider<CategorySubmitNotifier, CategorySubmitState>(
      (ref) => CategorySubmitNotifier(ref.read(categoryRepositoryProvider)),
    );

class CategorySubmitNotifier extends StateNotifier<CategorySubmitState> {
  final CategoryRepository repository;

  CategorySubmitNotifier(this.repository) : super(CategorySubmitInitial());

  Future<void> insertCategory({required CategoryModel request}) async {
    state = CategorySubmitLoading();

    try {
      await repository.insertCategory(request: request);
      state = CategorySubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = CategorySubmitValidationError(e.errors);
      } else {
        state = CategorySubmitError(e.toString());
      }
    }
  }

  Future<void> updateCategory({
    required CategoryModel request,
    required int id,
  }) async {
    state = CategorySubmitLoading();

    try {
      await repository.updateCategory(request: request, id: id);
      state = CategorySubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = CategorySubmitValidationError(e.errors);
      } else {
        state = CategorySubmitError(e.toString());
      }
    }
  }

  Future<void> deleteCategory({required int id}) async {
    state = CategorySubmitLoading();

    try {
      await repository.deleteCategory(id: id);
      state = CategorySubmitSuccess();
    } catch (e) {
      if (e is ValidationException) {
        state = CategorySubmitValidationError(e.errors);
      } else {
        state = CategorySubmitError(e.toString());
      }
    }
  }
}
