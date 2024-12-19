import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/kursus.dart';

class AddEditKursus extends StatefulWidget {
  final Kursus? kursus;

  const AddEditKursus({super.key, this.kursus});

  @override
  _AddEditKursusState createState() => _AddEditKursusState();
}

class _AddEditKursusState extends State<AddEditKursus> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  late String nama;
  late String deskripsi;
  late String instruktur;
  late String jadwal;
  late String lokasi;
  String? kategori;

  // Daftar Kategori IT
  final List<String> _kategoriList = [
    'Koding',
    'Desain Grafis',
    'Jaringan',
    'Keamanan Siber',
    'Pengembangan Mobile',
    'Database',
    'Cloud Computing',
    'AI & Machine Learning',
    'UI/UX Design',
    'DevOps',
  ];

  @override
  void initState() {
    super.initState();
    nama = widget.kursus?.nama ?? '';
    deskripsi = widget.kursus?.deskripsi ?? '';
    instruktur = widget.kursus?.instruktur ?? '';
    jadwal = widget.kursus?.jadwal ?? '';
    lokasi = widget.kursus?.lokasi ?? '';
    kategori = widget.kursus?.kategori ?? _kategoriList[0];
  }

  void _saveKursus() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Kursus kursus = Kursus(
        id: widget.kursus?.id,
        nama: nama,
        deskripsi: deskripsi,
        instruktur: instruktur,
        jadwal: jadwal,
        lokasi: lokasi,
        kategori: kategori!,
      );
      if (widget.kursus == null) {
        await dbHelper.insertKursus(kursus);
      } else {
        await dbHelper.updateKursus(kursus);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.kursus == null ? 'Tambah Kursus' : 'Ubah Kursus'),
          backgroundColor: Colors.blueAccent, // Warna header
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: nama,
                    decoration: const InputDecoration(labelText: 'Nama Kursus'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => nama = value!,
                  ),
                  TextFormField(
                    initialValue: deskripsi,
                    decoration:
                        const InputDecoration(labelText: 'Deskripsi Kursus'),
                    onSaved: (value) => deskripsi = value ?? '',
                  ),
                  TextFormField(
                    initialValue: instruktur,
                    decoration:
                        const InputDecoration(labelText: 'Instruktur'),
                    onSaved: (value) => instruktur = value ?? '',
                  ),
                  TextFormField(
                    initialValue: jadwal,
                    decoration: const InputDecoration(labelText: 'Jadwal'),
                    onSaved: (value) => jadwal = value ?? '',
                  ),
                  TextFormField(
                    initialValue: lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                    onSaved: (value) => lokasi = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: kategori,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _kategoriList
                        .map((kategori) => DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        kategori = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kategori harus dipilih';
                      }
                      return null;
                    },
                    onSaved: (value) => kategori = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveKursus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Warna tombol
                    ),
                    child: const Text('Simpan'),
                  )
                ],
              )),
        ),
        backgroundColor: Colors.grey[100]); // Background soft
  }
}
