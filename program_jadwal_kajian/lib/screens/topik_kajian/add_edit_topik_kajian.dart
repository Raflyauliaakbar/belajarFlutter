// lib/screens/topik_kajian/add_edit_topik_kajian.dart

import 'package:flutter/material.dart';
import '../../db/dbhelper.dart';
import '../../models/topik_kajian.dart';

class AddEditTopikKajian extends StatefulWidget {
  final TopikKajian? topikKajian;
  final int? jadwalKajianId;

  const AddEditTopikKajian({super.key, this.topikKajian, this.jadwalKajianId});

  @override
  _AddEditTopikKajianState createState() => _AddEditTopikKajianState();
}

class _AddEditTopikKajianState extends State<AddEditTopikKajian> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = DBHelper.instance;

  late String topikNama;
  late String deskripsi;
  late String materi;
  late int jadwalKajianId;

  @override
  void initState() {
    super.initState();
    topikNama = widget.topikKajian?.topikNama ?? '';
    deskripsi = widget.topikKajian?.deskripsi ?? '';
    materi = widget.topikKajian?.materi ?? '';
    jadwalKajianId = widget.topikKajian?.jadwalKajianId ?? widget.jadwalKajianId!;
  }

  void _saveTopikKajian() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      TopikKajian topikKajian = TopikKajian(
        id: widget.topikKajian?.id,
        jadwalKajianId: jadwalKajianId,
        topikNama: topikNama,
        deskripsi: deskripsi,
        materi: materi,
      );

      if (widget.topikKajian == null) {
        await dbHelper.insertTopikKajian(topikKajian);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Topik Kajian berhasil ditambahkan')),
        );
      } else {
        await dbHelper.updateTopikKajian(topikKajian);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Topik Kajian berhasil diperbarui')),
        );
      }

      Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topikKajian == null ? 'Tambah Topik Kajian' : 'Edit Topik Kajian'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nama Topik',
                initialValue: topikNama,
                onSaved: (value) => topikNama = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama topik tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Deskripsi',
                initialValue: deskripsi,
                onSaved: (value) => deskripsi = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              _buildTextField(
                label: 'Materi',
                initialValue: materi,
                onSaved: (value) => materi = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Materi tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTopikKajian,
                child: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
