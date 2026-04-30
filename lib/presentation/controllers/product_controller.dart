import 'package:get/get.dart';
import 'package:kinbii/data/models/product_model.dart';
import 'package:kinbii/domain/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;

  ProductController(this.repository);

  var products = <ProductModel>[].obs;
  var categoryProducts = <ProductModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final result = await repository.getProducts();
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => products.value = data,
    );
    isLoading.value = false;
  }

  Future<void> fetchProductsByCategory(String categoryName) async {
    isLoading.value = true;
    final result = await repository.getProductsByCategory(categoryName);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => categoryProducts.value = data,
    );
    isLoading.value = false;
  }

  Future<ProductModel?> addProduct(ProductModel product) async {
    ProductModel? created;
    final result = await repository.addProduct(product);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) {
        products.add(data);
        created = data;
      },
    );
    return created;
  }

  Future<void> updateProduct(int index, ProductModel product) async {
    final result = await repository.updateProduct(product);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) {
        if (index >= 0 && index < categoryProducts.length &&
            categoryProducts[index].id == data.id) {
          categoryProducts[index] = data;
          categoryProducts.refresh();
        } else {
          final categoryIndex = categoryProducts.indexWhere((p) => p.id == data.id);
          if (categoryIndex != -1) {
            categoryProducts[categoryIndex] = data;
            categoryProducts.refresh();
          }
        }

        final idx = products.indexWhere((p) => p.id == data.id);
        if (idx != -1) {
          products[idx] = data;
          products.refresh();
        }
      },
    );
  }

  Future<void> deleteProduct(int id, int index) async {
    final result = await repository.deleteProduct(id);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) {
        categoryProducts.removeAt(index);
        products.removeWhere((p) => p.id == id);
      },
    );
  }

  int getCountProductByCategory(String categoryName) {
    return products.where((p) => p.categoryName == categoryName).length;
  }
}
