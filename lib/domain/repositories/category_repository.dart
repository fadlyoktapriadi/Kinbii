import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, CategoryModel>> addCategory(CategoryModel category);
  Future<Either<Failure, CategoryModel>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> deleteCategory(int id);
}

