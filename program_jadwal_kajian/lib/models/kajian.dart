// lib/models/kajian.dart

class Kajian {
  final int? id;
  final String namaKajian;
  final String pembicara;
  final String hariTanggal;
  final String tempatAcara;
  final String kategori;

  Kajian({
    this.id,
    required this.namaKajian,
    required this.pembicara,
    required this.hariTanggal,
    required this.tempatAcara,
    required this.kategori,
  });

  // Mengonversi objek Kajian ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kajian': namaKajian,
      'pembicara': pembicara,
      'hariTanggal': hariTanggal,
      'tempat_acara': tempatAcara,
      'kategori': kategori,
    };
  }

  // Membuat objek Kajian dari Map
  factory Kajian.fromMap(Map<String, dynamic> map) {
    return Kajian(
      id: map['id'],
      namaKajian: map['nama_kajian'],
      pembicara: map['pembicara'],
      hariTanggal: map['hariTanggal'],
      tempatAcara: map['tempat_acara'],
      kategori: map['kategori'],
    );
  }
}
