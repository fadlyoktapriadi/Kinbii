import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';
import 'package:kinbii/data/models/category_model.dart';
import 'package:kinbii/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableCategories);
      List<CategoryModel> categories = maps.map((map) => CategoryModel.fromMap(map)).toList();
      return Right(categories);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> addCategory(CategoryModel category) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tableCategories, category.toMap());
      return Right(category.copyWith(id: id));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> updateCategory(CategoryModel category) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        DatabaseHelper.tableCategories,
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      return Right(category);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        DatabaseHelper.tableCategories,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

