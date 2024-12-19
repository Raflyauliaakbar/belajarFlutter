class Kursus {
  int? id;
  String nama;
  String deskripsi;
  String instruktur;
  String jadwal;
  String lokasi;
  String kategori;

  Kursus({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.instruktur,
    required this.jadwal,
    required this.lokasi,
    required this.kategori,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nama': nama,
      'deskripsi': deskripsi,
      'instruktur': instruktur,
      'jadwal': jadwal,
      'lokasi': lokasi,
      'kategori': kategori,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Kursus.fromMap(Map<String, dynamic> map) {
    return Kursus(
      id: map['id'],
      nama: map['nama'],
      deskripsi: map['deskripsi'],
      instruktur: map['instruktur'],
      jadwal: map['jadwal'],
      lokasi: map['lokasi'],
      kategori: map['kategori'],
    );
  }
}
