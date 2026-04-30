import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';
import 'package:kinbii/data/models/product_movement_model.dart';
import 'package:kinbii/domain/repositories/product_movement_repository.dart';

class ProductMovementRepositoryImpl implements ProductMovementRepository {
  final DatabaseHelper databaseHelper;

  ProductMovementRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<ProductMovementModel>>> getMovements() async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(DatabaseHelper.tableProductMovements, orderBy: 'id DESC');
      return Right(maps.map((map) => ProductMovementModel.fromMap(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductMovementModel>>> getMovementsByType(String type) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(
        DatabaseHelper.tableProductMovements,
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'id DESC',
      );
      return Right(maps.map((map) => ProductMovementModel.fromMap(map)).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductMovementModel>> addMovement(ProductMovementModel movement) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tableProductMovements, movement.toMap());
      return Right(ProductMovementModel(
        id: id,
        productId: movement.productId,
        productName: movement.productName,
        categoryName: movement.categoryName,
        storageName: movement.storageName,
        quantity: movement.quantity,
        type: movement.type,
        date: movement.date,
      ));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

