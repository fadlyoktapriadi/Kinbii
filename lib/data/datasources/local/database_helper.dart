import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = "kinbii.db";
  static const _databaseVersion = 3;

  static const tableCategories = 'categories';
  static const tableStorages = 'storages';
  static const tableProducts = 'products';
  static const tableProductMovements = 'product_movements';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $tableProducts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          categoryName TEXT NOT NULL,
          storageName TEXT NOT NULL,
          stock INTEGER NOT NULL,
          dateIn TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE $tableProductMovements (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER NOT NULL,
          productName TEXT NOT NULL,
          categoryName TEXT NOT NULL,
          storageName TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableStorages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        categoryName TEXT NOT NULL,
        storageName TEXT NOT NULL,
        stock INTEGER NOT NULL,
        dateIn TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProductMovements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        categoryName TEXT NOT NULL,
        storageName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), _databaseName);
  }
}
