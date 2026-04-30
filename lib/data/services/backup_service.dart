import 'dart:convert';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:kinbii/data/datasources/local/database_helper.dart';

class BackupService {
  final DatabaseHelper databaseHelper;

  BackupService(this.databaseHelper);

  Future<String> exportBackupAsJson() async {
    final db = await databaseHelper.database;
    final categories = await db.query(DatabaseHelper.tableCategories);
    final storages = await db.query(DatabaseHelper.tableStorages);
    final products = await db.query(DatabaseHelper.tableProducts);
    final movements = await db.query(DatabaseHelper.tableProductMovements);

    final backupPayload = <String, dynamic>{
      'meta': {
        'app': 'Kinbii',
        'formatVersion': 1,
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'data': {
        DatabaseHelper.tableCategories: categories,
        DatabaseHelper.tableStorages: storages,
        DatabaseHelper.tableProducts: products,
        DatabaseHelper.tableProductMovements: movements,
      },
    };

    return const JsonEncoder.withIndent('  ').convert(backupPayload);
  }

  Future<void> importBackupFromBytes(Uint8List bytes) async {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup file format is invalid');
    }

    final payload = _parsePayload(decoded);
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      await txn.delete(DatabaseHelper.tableProductMovements);
      await txn.delete(DatabaseHelper.tableProducts);
      await txn.delete(DatabaseHelper.tableCategories);
      await txn.delete(DatabaseHelper.tableStorages);

      await _insertRows(
        txn: txn,
        table: DatabaseHelper.tableCategories,
        rows: payload.categories,
      );
      await _insertRows(
        txn: txn,
        table: DatabaseHelper.tableStorages,
        rows: payload.storages,
      );
      await _insertRows(
        txn: txn,
        table: DatabaseHelper.tableProducts,
        rows: payload.products,
      );
      await _insertRows(
        txn: txn,
        table: DatabaseHelper.tableProductMovements,
        rows: payload.movements,
      );
    });
  }

  Future<void> _insertRows({
    required Transaction txn,
    required String table,
    required List<Map<String, dynamic>> rows,
  }) async {
    for (final row in rows) {
      await txn.insert(
        table,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  _BackupPayload _parsePayload(Map<String, dynamic> decoded) {
    final rawData = decoded['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const FormatException('Backup file data section is missing');
    }

    return _BackupPayload(
      categories: _parseCategories(rawData[DatabaseHelper.tableCategories]),
      storages: _parseStorages(rawData[DatabaseHelper.tableStorages]),
      products: _parseProducts(rawData[DatabaseHelper.tableProducts]),
      movements: _parseMovements(rawData[DatabaseHelper.tableProductMovements]),
    );
  }

  List<Map<String, dynamic>> _parseCategories(dynamic rows) {
    return _parseRows(rows).map((row) {
      return {
        'id': _toInt(row['id']),
        'name': _toString(row['name']),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _parseStorages(dynamic rows) {
    return _parseRows(rows).map((row) {
      return {
        'id': _toInt(row['id']),
        'name': _toString(row['name']),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _parseProducts(dynamic rows) {
    return _parseRows(rows).map((row) {
      return {
        'id': _toInt(row['id']),
        'name': _toString(row['name']),
        'categoryName': _toString(row['categoryName']),
        'storageName': _toString(row['storageName']),
        'stock': _toInt(row['stock']),
        'dateIn': _toString(row['dateIn']),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _parseMovements(dynamic rows) {
    return _parseRows(rows).map((row) {
      return {
        'id': _toInt(row['id']),
        'productId': _toInt(row['productId']),
        'productName': _toString(row['productName']),
        'categoryName': _toString(row['categoryName']),
        'storageName': _toString(row['storageName']),
        'quantity': _toInt(row['quantity']),
        'type': _toString(row['type']),
        'date': _toString(row['date']),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _parseRows(dynamic rows) {
    if (rows == null) {
      return <Map<String, dynamic>>[];
    }
    if (rows is! List) {
      throw const FormatException('Backup table payload must be a list');
    }

    return rows.map((row) {
      if (row is! Map) {
        throw const FormatException('Backup row payload must be an object');
      }
      return Map<String, dynamic>.from(row);
    }).toList();
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.parse(value);
    throw const FormatException('Expected integer value');
  }

  String _toString(dynamic value) {
    if (value == null) {
      throw const FormatException('Expected non-null string value');
    }
    return value.toString();
  }
}

class _BackupPayload {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> storages;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> movements;

  _BackupPayload({
    required this.categories,
    required this.storages,
    required this.products,
    required this.movements,
  });
}
