import 'package:get_it/get_it.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';
import 'package:kinbii/data/repositories/category_repository_impl.dart';
import 'package:kinbii/data/repositories/storage_repository_impl.dart';
import 'package:kinbii/data/repositories/product_movement_repository_impl.dart';
import 'package:kinbii/domain/repositories/category_repository.dart';
import 'package:kinbii/domain/repositories/storage_repository.dart';
import 'package:kinbii/domain/repositories/product_repository.dart';
import 'package:kinbii/domain/repositories/product_movement_repository.dart';
import 'package:kinbii/presentation/controllers/category_controller.dart';
import 'package:kinbii/presentation/controllers/storage_controller.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';
import 'package:kinbii/presentation/controllers/report_controller.dart';

final sl = GetIt.instance;

void init() {
  // Data sources
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Repositories
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StorageRepository>(
    () => StorageRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductMovementRepository>(
    () => ProductMovementRepositoryImpl(sl()),
  );

  // Controllers (ViewModels)
  sl.registerFactory(() => CategoryController(sl()));
  sl.registerFactory(() => StorageController(sl()));
  sl.registerFactory(() => ProductController(sl()));
  sl.registerFactory(() => ReportController(sl()));
}
