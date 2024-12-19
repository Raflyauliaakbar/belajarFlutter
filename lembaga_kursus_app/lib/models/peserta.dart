class Peserta {
  int? id;
  String nama;
  String email;
  String noHp;
  String alamat;
  String jenkel;

  Peserta({
    this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.jenkel,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'alamat': alamat,
      'jenkel': jenkel,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Peserta.fromMap(Map<String, dynamic> map) {
    return Peserta(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      noHp: map['noHp'],
      alamat: map['alamat'],
      jenkel: map['jenkel'],
    );
  }
}
