// lib/db/dbhelper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/kajian.dart';
import '../models/topik_kajian.dart';

class DBHelper {
  // Singleton pattern
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'jadwal_kajian.db');
    return await openDatabase(
      path,
      version: 2, // Naikkan versi database untuk migrasi
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Membuat tabel jadwal_kajian dengan tambahan kolom kategori
    await db.execute('''
      CREATE TABLE jadwal_kajian (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_kajian TEXT NOT NULL,
        pembicara TEXT NOT NULL,
        hariTanggal TEXT NOT NULL,
        tempat_acara TEXT NOT NULL,
        kategori TEXT NOT NULL
      )
    ''');

    // Membuat tabel topik_kajian dengan tambahan kolom materi
    await db.execute('''
      CREATE TABLE topik_kajian (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jadwal_kajian_id INTEGER NOT NULL,
        topik_nama TEXT NOT NULL,
        deskripsi TEXT,
        materi TEXT NOT NULL,
        FOREIGN KEY (jadwal_kajian_id) REFERENCES jadwal_kajian(id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Menambahkan kolom kategori ke tabel jadwal_kajian
      await db.execute('''
        ALTER TABLE jadwal_kajian ADD COLUMN kategori TEXT NOT NULL DEFAULT 'Umum'
      ''');
      
      // Menambahkan kolom materi ke tabel topik_kajian
      await db.execute('''
        ALTER TABLE topik_kajian ADD COLUMN materi TEXT NOT NULL DEFAULT ''
      ''');
    }
    // Tambahkan migrasi lainnya jika diperlukan di masa depan
  }

  // --------------------- CRUD Operasi untuk Jadwal Kajian ---------------------

  Future<int> insertKajian(Kajian kajian) async {
    Database db = await instance.database;
    return await db.insert('jadwal_kajian', kajian.toMap());
  }

  Future<List<Kajian>> getAllKajian() async {
    Database db = await instance.database;
    var kajian = await db.query('jadwal_kajian', orderBy: 'hariTanggal DESC');
    List<Kajian> kajianList = kajian.isNotEmpty
        ? kajian.map((c) => Kajian.fromMap(c)).toList()
        : [];
    return kajianList;
  }

  Future<int> updateKajian(Kajian kajian) async {
    Database db = await instance.database;
    return await db.update('jadwal_kajian', kajian.toMap(),
        where: 'id = ?', whereArgs: [kajian.id]);
  }

  Future<int> deleteKajian(int id) async {
    Database db = await instance.database;
    return await db.delete('jadwal_kajian', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------- CRUD Operasi untuk Topik Kajian ---------------------

  Future<int> insertTopikKajian(TopikKajian topikKajian) async {
    Database db = await instance.database;
    return await db.insert('topik_kajian', topikKajian.toMap());
  }

  Future<List<TopikKajian>> getTopikKajian(int jadwalKajianId) async {
    Database db = await instance.database;
    var topik = await db.query('topik_kajian',
        where: 'jadwal_kajian_id = ?', whereArgs: [jadwalKajianId]);
    List<TopikKajian> topikList = topik.isNotEmpty
        ? topik.map((c) => TopikKajian.fromMap(c)).toList()
        : [];
    return topikList;
  }

  Future<int> updateTopikKajian(TopikKajian topikKajian) async {
    Database db = await instance.database;
    return await db.update('topik_kajian', topikKajian.toMap(),
        where: 'id = ?', whereArgs: [topikKajian.id]);
  }

  Future<int> deleteTopikKajian(int id) async {
    Database db = await instance.database;
    return await db.delete('topik_kajian', where: 'id = ?', whereArgs: [id]);
  }
}
