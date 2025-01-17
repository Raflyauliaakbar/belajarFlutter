import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/camera.dart';
import 'models/rental.dart';

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
    // Update the database name
    String path = join(await getDatabasesPath(), 'new_db_sewa_kamera.db');
    print('Database path: $path'); // Log database path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Cameras (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      brand TEXT NOT NULL,
      price REAL NOT NULL,
      status TEXT NOT NULL,
      description TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE Rentals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT NOT NULL,
        camera_id INTEGER NOT NULL,
        rental_date TEXT NOT NULL,
        return_date TEXT,
        contact TEXT NOT NULL,
        FOREIGN KEY (camera_id) REFERENCES Cameras(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> deleteOldDatabase() async {
    String oldPath = join(await getDatabasesPath(), 'db_sewa_kamera.db'); // Old database name
    await deleteDatabase(oldPath);
    print('Old database deleted: $oldPath');
  }

  // CRUD operations for Cameras
  Future<int> insertCamera(Camera camera) async {
    Database db = await database;
    return await db.insert('Cameras', camera.toMap());
  }

  Future<List<Camera>> getCameras() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Cameras');
    return maps.map((map) => Camera.fromMap(map)).toList();
  }

  Future<int> updateCamera(Camera camera) async {
    Database db = await database;
    return await db.update(
      'Cameras',
      camera.toMap(),
      where: 'id = ?',
      whereArgs: [camera.id],
    );
  }

  Future<int> deleteCamera(int id) async {
    Database db = await database;
    return await db.delete(
      'Cameras',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Camera>> searchCameras(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Cameras',
      where: 'name LIKE ? OR brand LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => Camera.fromMap(map)).toList();
  }

  // CRUD operations for Rentals
  Future<int> insertRental(Rental rental) async {
    Database db = await database;
    return await db.insert('Rentals', rental.toMap());
  }

  Future<List<Rental>> getRentals() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Rentals');
    return maps.map((map) => Rental.fromMap(map)).toList();
  }

  Future<int> updateRental(Rental rental) async {
    Database db = await database;
    return await db.update(
      'Rentals',
      rental.toMap(),
      where: 'id = ?',
      whereArgs: [rental.id],
    );
  }

  Future<int> deleteRental(int id) async {
    Database db = await database;
    return await db.delete(
      'Rentals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Rental>> searchRentals(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Rentals',
      where: 'customer_name LIKE ? OR contact LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((map) => Rental.fromMap(map)).toList();
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, Function onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Perform delete
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
