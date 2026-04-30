import 'package:get/get.dart';
import 'package:kinbii/data/models/product_movement_model.dart';
import 'package:kinbii/domain/repositories/product_movement_repository.dart';

class ReportController extends GetxController {
  final ProductMovementRepository repository;

  ReportController(this.repository);

  var movements = <ProductMovementModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovements();
  }

  Future<void> fetchMovements() async {
    isLoading.value = true;
    final result = await repository.getMovements();
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => movements.value = data,
    );
    isLoading.value = false;
  }

  Future<void> addMovement(ProductMovementModel movement) async {
    final result = await repository.addMovement(movement);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => movements.insert(0, data),
    );
  }

  List<ProductMovementModel> get inMovements =>
      movements.where((m) => m.type == 'IN').toList();

  List<ProductMovementModel> get outMovements =>
      movements.where((m) => m.type == 'OUT').toList();

  int get totalIn => inMovements.fold(0, (sum, m) => sum + m.quantity);

  int get totalOut => outMovements.fold(0, (sum, m) => sum + m.quantity);
}

