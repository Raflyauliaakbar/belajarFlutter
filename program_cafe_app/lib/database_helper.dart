import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/menu.dart';
import 'models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'db_cafe.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Menu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        menu_id INTEGER,
        quantity INTEGER NOT NULL,
        total_price REAL NOT NULL,
        date TEXT,
        FOREIGN KEY (menu_id) REFERENCES Menu(id) ON DELETE CASCADE
      )
    ''');
  }

  // CRUD operations for Menu
  Future<int> insertMenu(Menu menu) async {
    Database db = await database;
    return await db.insert('Menu', menu.toMap());
  }

  Future<List<Menu>> getMenus() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Menu');
    return maps.map((map) => Menu.fromMap(map)).toList();
  }

  Future<int> updateMenu(Menu menu) async {
    Database db = await database;
    return await db.update(
      'Menu',
      menu.toMap(),
      where: 'id = ?',
      whereArgs: [menu.id],
    );
  }

  Future<int> deleteMenu(int id) async {
    Database db = await database;
    return await db.delete(
      'Menu',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for Orders
  Future<int> insertOrder(Order order) async {
    Database db = await database;
    return await db.insert('Orders', order.toMap());
  }

  Future<List<Order>> getOrders() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Orders');
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<int> updateOrder(Order order) async {
    Database db = await database;
    return await db.update(
      'Orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> deleteOrder(int id) async {
    Database db = await database;
    return await db.delete(
      'Orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search functionality
  Future<List<Menu>> searchMenus(String keyword) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Menu',
      where: 'name LIKE ? OR category LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return maps.map((map) => Menu.fromMap(map)).toList();
  }

  Future<List<Order>> searchOrders(String keyword) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Orders',
      where: 'date LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return maps.map((map) => Order.fromMap(map)).toList();
  }
}
