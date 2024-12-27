// lib/models/topik_kajian.dart

class TopikKajian {
  final int? id;
  final int jadwalKajianId;
  final String topikNama;
  final String deskripsi;
  final String materi;

  TopikKajian({
    this.id,
    required this.jadwalKajianId,
    required this.topikNama,
    required this.deskripsi,
    required this.materi,
  });

  // Mengonversi objek TopikKajian ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jadwal_kajian_id': jadwalKajianId,
      'topik_nama': topikNama,
      'deskripsi': deskripsi,
      'materi': materi,
    };
  }

  // Membuat objek TopikKajian dari Map
  factory TopikKajian.fromMap(Map<String, dynamic> map) {
    return TopikKajian(
      id: map['id'],
      jadwalKajianId: map['jadwal_kajian_id'],
      topikNama: map['topik_nama'],
      deskripsi: map['deskripsi'],
      materi: map['materi'],
    );
  }
}
