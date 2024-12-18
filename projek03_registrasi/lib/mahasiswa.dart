class Mahasiswa {
  final String npm, namaLengkap, prodi, jenkel;

  Mahasiswa({
    required this.npm,
    required this.namaLengkap,
    required this.prodi,
    required this.jenkel,
  });

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      npm: map["npm"],
      namaLengkap: map["namaLengkap"],
      prodi: map["prodi"],
      jenkel: map["jenkel"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "npm": npm,
      "namaLengkap": namaLengkap,
      "prodi": prodi,
      "jenkel": jenkel,
    };
  }
}
