import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/models/storage_model.dart';

abstract class StorageRepository {
  Future<Either<Failure, List<StorageModel>>> getStorages();
  Future<Either<Failure, StorageModel>> addStorage(StorageModel storage);
  Future<Either<Failure, StorageModel>> updateStorage(StorageModel storage);
  Future<Either<Failure, void>> deleteStorage(int id);
}

