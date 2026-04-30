import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/models/product_model.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String categoryName);
  Future<Either<Failure, ProductModel>> addProduct(ProductModel product);
  Future<Either<Failure, ProductModel>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseHelper databaseHelper;

  ProductRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableProducts);
      return Right(maps.map((map) => ProductModel.fromMap(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String categoryName) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableProducts,
        where: 'categoryName = ?',
        whereArgs: [categoryName],
      );
      return Right(maps.map((map) => ProductModel.fromMap(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> addProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tableProducts, product.toMap());
      return Right(ProductModel(
        id: id,
        name: product.name,
        categoryName: product.categoryName,
        storageName: product.storageName,
        stock: product.stock,
        dateIn: product.dateIn,
      ));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        DatabaseHelper.tableProducts,
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      return Right(product);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        DatabaseHelper.tableProducts,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
