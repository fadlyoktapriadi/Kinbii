import 'package:dartz/dartz.dart';
import 'package:kinbii/core/errors/failures.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';
import 'package:kinbii/data/models/storage_model.dart';
import 'package:kinbii/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final DatabaseHelper databaseHelper;

  StorageRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<StorageModel>>> getStorages() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableStorages);
      List<StorageModel> storages = maps.map((map) => StorageModel.fromMap(map)).toList();
      return Right(storages);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StorageModel>> addStorage(StorageModel storage) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tableStorages, storage.toMap());
      return Right(storage.copyWith(id: id));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StorageModel>> updateStorage(StorageModel storage) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        DatabaseHelper.tableStorages,
        storage.toMap(),
        where: 'id = ?',
        whereArgs: [storage.id],
      );
      return Right(storage);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStorage(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        DatabaseHelper.tableStorages,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

