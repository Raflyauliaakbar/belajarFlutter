import 'dart:async';

import 'package:path/path.dart';
import 'package:projek03_registrasi/mahasiswa.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static final Dbhelper _instance = Dbhelper._internal();
  static Database? _database;

  Dbhelper._internal();

  factory Dbhelper() {
    return _instance;
  }

  // Mengambil atau menginisialisasi database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'uniska.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
CREATE TABLE mahasiswa (
npm TEXT PRIMARY KEY,
namaLengkap TEXT,
prodi TEXT,
jenkel TEXT
)
''');
    });
  }

  // Fungsi mendapatkan data mahasiswa (dengan filter pencarian opsional)
  Future<List<Mahasiswa>> getMahasiswa({String? query}) async {
    final db = await database;

    // Jika query kosong/null, ambil semua data
    if (query == null || query.isEmpty) {
      final List<Map<String, dynamic>> maps = await db.query('mahasiswa');
      return List.generate(maps.length, (i) => Mahasiswa.fromMap(maps[i]));
    } else {
      // Filter data berdasarkan namaLengkap menggunakan LIKE
      final List<Map<String, dynamic>> maps = await db.query(
        'mahasiswa',
        where: 'namaLengkap LIKE ?',
        whereArgs: ['%$query%'],
      );
      return List.generate(maps.length, (i) => Mahasiswa.fromMap(maps[i]));
    }
  }

  // Fungsi insert data mahasiswa
  Future<int> insertMahasiswa(Mahasiswa mhs) async {
    final db = await database;
    return await db.insert("mahasiswa", mhs.toMap());
  }

  // Fungsi hapus data mahasiswa berdasarkan NPM
  Future<int> deleteMahasiswa(String npm) async {
    final db = await database;
    return await db.delete("mahasiswa", where: "npm = ?", whereArgs: [npm]);
  }

  // Fungsi update data mahasiswa
  Future<int> updateMahasiswa(Mahasiswa mhs) async {
    final db = await database;
    return await db.update(
      "mahasiswa",
      mhs.toMap(),
      where: "npm = ?",
      whereArgs: [mhs.npm],
    );
  }
}
