import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/models/product_movement_model.dart';

abstract class ProductMovementRepository {
  Future<Either<Failure, List<ProductMovementModel>>> getMovements();
  Future<Either<Failure, List<ProductMovementModel>>> getMovementsByType(String type);
  Future<Either<Failure, ProductMovementModel>> addMovement(ProductMovementModel movement);
}

