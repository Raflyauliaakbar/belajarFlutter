import 'package:flutter/material.dart';
import 'package:projek03_registrasi/dbhelper.dart';
import 'package:projek03_registrasi/mahasiswa.dart';

class EditPage extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditPage({Key? key, required this.mahasiswa}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _prodiController = TextEditingController();
  late String _jenkel;

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.mahasiswa.namaLengkap;
    _prodiController.text = widget.mahasiswa.prodi;

    // Pastikan _jenkel memiliki nilai default yang cocok
    _jenkel = (widget.mahasiswa.jenkel == 'Laki-laki' ||
            widget.mahasiswa.jenkel == 'Perempuan')
        ? widget.mahasiswa.jenkel
        : 'Laki-laki'; // fallback jika nilainya tidak cocok
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      Mahasiswa updatedMahasiswa = Mahasiswa(
        npm: widget.mahasiswa.npm,
        namaLengkap: _namaController.text,
        prodi: _prodiController.text,
        jenkel: _jenkel,
      );
      await Dbhelper().updateMahasiswa(updatedMahasiswa);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _prodiController,
                decoration: const InputDecoration(labelText: 'Prodi'),
                validator: (value) =>
                    value!.isEmpty ? 'Prodi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _jenkel,
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _jenkel = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
