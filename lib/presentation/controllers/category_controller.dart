import 'package:get/get.dart';
import 'package:kinbii/data/models/category_model.dart';
import 'package:kinbii/domain/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository;

  CategoryController(this.repository);

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    final result = await repository.getCategories();
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => categories.value = data,
    );
    isLoading.value = false;
  }

  Future<void> addCategory(String name) async {
    final category = CategoryModel(name: name);
    final result = await repository.addCategory(category);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => categories.add(data),
    );
  }

  Future<void> updateCategory(int index, CategoryModel category) async {
    final result = await repository.updateCategory(category);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) {
        categories[index] = data;
        categories.refresh();
      },
    );
  }

  Future<void> deleteCategory(int id, int index) async {
    final result = await repository.deleteCategory(id);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) => categories.removeAt(index),
    );
  }
}

