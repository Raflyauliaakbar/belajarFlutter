import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'mahasiswa.dart';

class PageRegistrasi extends StatefulWidget {
  const PageRegistrasi({Key? key}) : super(key: key);

  @override
  _PageRegistrasiState createState() => _PageRegistrasiState();
}

class _PageRegistrasiState extends State<PageRegistrasi> {
  final Dbhelper _dbHelper = Dbhelper();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  String _jenKel = 'Laki-laki';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Mahasiswa'),
        backgroundColor: Colors.green.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _npmController,
                decoration: const InputDecoration(labelText: 'NPM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NPM harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prodiController,
                decoration: const InputDecoration(labelText: 'Program Studi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Program Studi harus diisi';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenKel,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenKel = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Mahasiswa newMahasiswa = Mahasiswa(
        npm: _npmController.text,
        namaLengkap: _namaController.text,
        prodi: _prodiController.text,
        jenkel: _jenKel,
      );

      await _dbHelper.insertMahasiswa(newMahasiswa);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Mahasiswa Berhasil Disimpan')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _npmController.dispose();
    _namaController.dispose();
    _prodiController.dispose();
    super.dispose();
  }
}