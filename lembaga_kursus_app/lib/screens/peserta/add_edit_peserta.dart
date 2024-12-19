import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/peserta.dart';

class AddEditPeserta extends StatefulWidget {
  final Peserta? peserta;

  const AddEditPeserta({super.key, this.peserta});

  @override
  _AddEditPesertaState createState() => _AddEditPesertaState();
}

class _AddEditPesertaState extends State<AddEditPeserta> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  late String nama;
  late String email;
  late String noHp;
  late String alamat;
  String? jenkel;

  @override
  void initState() {
    super.initState();
    nama = widget.peserta?.nama ?? '';
    email = widget.peserta?.email ?? '';
    noHp = widget.peserta?.noHp ?? '';
    alamat = widget.peserta?.alamat ?? '';
    jenkel = widget.peserta?.jenkel ?? 'Laki-laki';
  }

  void _savePeserta() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Peserta peserta = Peserta(
        id: widget.peserta?.id,
        nama: nama,
        email: email,
        noHp: noHp,
        alamat: alamat,
        jenkel: jenkel!,
      );
      if (widget.peserta == null) {
        await dbHelper.insertPeserta(peserta);
      } else {
        await dbHelper.updatePeserta(peserta);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.peserta == null ? 'Tambah Peserta' : 'Ubah Peserta'),
          backgroundColor: Colors.greenAccent, // Warna header
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: nama,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => nama = value!,
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (value) => email = value ?? '',
                  ),
                  TextFormField(
                    initialValue: noHp,
                    decoration: const InputDecoration(labelText: 'No. HP'),
                    onSaved: (value) => noHp = value ?? '',
                  ),
                  TextFormField(
                    initialValue: alamat,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                    onSaved: (value) => alamat = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jenis Kelamin',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Laki-laki'),
                    leading: Radio<String>(
                      value: 'Laki-laki',
                      groupValue: jenkel,
                      onChanged: (value) {
                        setState(() {
                          jenkel = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Perempuan'),
                    leading: Radio<String>(
                      value: 'Perempuan',
                      groupValue: jenkel,
                      onChanged: (value) {
                        setState(() {
                          jenkel = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _savePeserta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent, // Warna tombol
                    ),
                    child: const Text('Simpan'),
                  )
                ],
              )),
        ),
        backgroundColor: Colors.grey[100]); // Background soft
  }
}
