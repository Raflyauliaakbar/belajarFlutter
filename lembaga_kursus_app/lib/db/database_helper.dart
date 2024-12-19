import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kursus.dart';
import '../models/peserta.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Mengambil atau menginisialisasi database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dbkursus.db');
    return await openDatabase(
      path,
      version: 3, // Tingkatkan versi untuk migrasi
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Membuat tabel saat database pertama kali dibuat
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kursus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        deskripsi TEXT,
        instruktur TEXT,
        jadwal TEXT,
        lokasi TEXT,
        kategori TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE peserta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT,
        noHp TEXT,
        alamat TEXT,
        jenkel TEXT NOT NULL
      )
    ''');
  }

  // Menangani migrasi database jika versi bertambah
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Versi 2: Menambahkan kolom 'kategori' pada tabel 'kursus'
      await db.execute('''
        ALTER TABLE kursus ADD COLUMN kategori TEXT NOT NULL DEFAULT 'Koding'
      ''');
    }
    if (oldVersion < 3) {
      // Versi 3: Menambahkan kolom 'jenkel' pada tabel 'peserta'
      await db.execute('''
        ALTER TABLE peserta ADD COLUMN jenkel TEXT NOT NULL DEFAULT 'Laki-laki'
      ''');
    }
    // Tambahkan kondisi migrasi lainnya jika ada versi selanjutnya
  }

  // --------------------- Operasi untuk Tabel Kursus ---------------------

  // 1. Insert Kursus
  Future<int> insertKursus(Kursus kursus) async {
    final db = await database;
    return await db.insert('kursus', kursus.toMap());
  }

  // 2. Get Semua Kursus
  Future<List<Kursus>> getKursus({String? query}) async {
    final db = await database;

    if (query == null || query.isEmpty) {
      final List<Map<String, dynamic>> maps = await db.query('kursus');
      return List.generate(maps.length, (i) => Kursus.fromMap(maps[i]));
    } else {
      final List<Map<String, dynamic>> maps = await db.query(
        'kursus',
        where: 'nama LIKE ?',
        whereArgs: ['%$query%'],
      );
      return List.generate(maps.length, (i) => Kursus.fromMap(maps[i]));
    }
  }

  // 3. Update Kursus
  Future<int> updateKursus(Kursus kursus) async {
    final db = await database;
    return await db.update(
      'kursus',
      kursus.toMap(),
      where: 'id = ?',
      whereArgs: [kursus.id],
    );
  }

  // 4. Delete Kursus
  Future<int> deleteKursus(int id) async {
    final db = await database;
    return await db.delete(
      'kursus',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Search Kursus berdasarkan Nama
  Future<List<Kursus>> searchKursus(String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kursus',
      where: 'nama LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return List.generate(maps.length, (i) => Kursus.fromMap(maps[i]));
  }

  // 6. Search Kursus berdasarkan Kategori
  Future<List<Kursus>> searchKursusByKategori(String kategori) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kursus',
      where: 'kategori = ?',
      whereArgs: [kategori],
    );
    return List.generate(maps.length, (i) => Kursus.fromMap(maps[i]));
  }

  // 7. Search Kursus berdasarkan Nama dan Kategori
  Future<List<Kursus>> searchKursusWithKategori(String keyword, String kategori) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kursus',
      where: 'nama LIKE ? AND kategori = ?',
      whereArgs: ['%$keyword%', kategori],
    );
    return List.generate(maps.length, (i) => Kursus.fromMap(maps[i]));
  }

  // --------------------- Operasi untuk Tabel Peserta ---------------------

  // 8. Insert Peserta
  Future<int> insertPeserta(Peserta peserta) async {
    final db = await database;
    return await db.insert('peserta', peserta.toMap());
  }

  // 9. Get Semua Peserta
  Future<List<Peserta>> getPeserta({String? query}) async {
    final db = await database;

    if (query == null || query.isEmpty) {
      final List<Map<String, dynamic>> maps = await db.query('peserta');
      return List.generate(maps.length, (i) => Peserta.fromMap(maps[i]));
    } else {
      final List<Map<String, dynamic>> maps = await db.query(
        'peserta',
        where: 'nama LIKE ?',
        whereArgs: ['%$query%'],
      );
      return List.generate(maps.length, (i) => Peserta.fromMap(maps[i]));
    }
  }

  // 10. Update Peserta
  Future<int> updatePeserta(Peserta peserta) async {
    final db = await database;
    return await db.update(
      'peserta',
      peserta.toMap(),
      where: 'id = ?',
      whereArgs: [peserta.id],
    );
  }

  // 11. Delete Peserta
  Future<int> deletePeserta(int id) async {
    final db = await database;
    return await db.delete(
      'peserta',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 12. Search Peserta berdasarkan Nama
  Future<List<Peserta>> searchPeserta(String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'peserta',
      where: 'nama LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return List.generate(maps.length, (i) => Peserta.fromMap(maps[i]));
  }
}
