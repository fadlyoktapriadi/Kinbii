import 'package:get/get.dart';
import 'package:kinbii/data/models/storage_model.dart';
import 'package:kinbii/domain/repositories/storage_repository.dart';

class StorageController extends GetxController {
  final StorageRepository repository;

  StorageController(this.repository);

  var storages = <StorageModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStorages();
  }

  Future<void> fetchStorages() async {
    isLoading.value = true;
    final result = await repository.getStorages();
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => storages.value = data,
    );
    isLoading.value = false;
  }

  Future<void> addStorage(String name) async {
    final storage = StorageModel(name: name);
    final result = await repository.addStorage(storage);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => storages.add(data),
    );
  }

  Future<void> updateStorage(int index, StorageModel storage) async {
    final result = await repository.updateStorage(storage);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) {
        storages[index] = data;
        storages.refresh();
      },
    );
  }

  Future<void> deleteStorage(int id, int index) async {
    final result = await repository.deleteStorage(id);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) => storages.removeAt(index),
    );
  }
}

