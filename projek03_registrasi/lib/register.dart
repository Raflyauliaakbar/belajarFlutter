import 'package:flutter/material.dart';
import 'package:projek03_registrasi/dbhelper.dart';
import 'package:projek03_registrasi/mahasiswa.dart';

class PageRegistrasi extends StatefulWidget {
  const PageRegistrasi({super.key});

  @override
  State<PageRegistrasi> createState() => _PageRegistrasiState();
}

class _PageRegistrasiState extends State<PageRegistrasi> {
  // untuk menampung nilai dari Form
  final _fromKey = GlobalKey<FormState>();
  // untuk inputan npm dan nama
  final npm = TextEditingController();
  final nama = TextEditingController();
// untuk menampung inputan pada combobox/DropDownButtonFormField
  String prodi = "Teknik Informatika";
  // untuk menampung nilai pada radio button/radioListTile
  String jenKel = "Pria";

  Future<void> _simpan() async {
    if (_fromKey.currentState!.validate()) {
      await Dbhelper().insertMahasiswa(Mahasiswa(
          npm: npm.text, namaLengkap: nama.text, prodi: prodi, jenkel: jenKel));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pendaftaran Berhasil Diproses")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Registrasi"),
        backgroundColor: Colors.green.shade500,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: npm,
                validator: (value) =>
                    (value == "") ? "NPM Tidak Boleh Kosong" : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Input NPM",
                  hintText: "Input NPM Anda",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nama,
                validator: (value) =>
                    (value == "") ? "Nama Tidak Boleh Kosong" : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Input Nama",
                  hintText: "Input Nama Anda",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                items: [
                  "Teknik Informatika",
                  "Sistem Informasi",
                  "Teknik Sipil",
                  "Farmasi",
                  "Kesehatan Masyarakat",
                ].map((prodi) {
                  return DropdownMenuItem(value: prodi, child: Text(prodi));
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pilih Prodi",
                ),
                validator: (value) =>
                    (value == null) ? "Prodi Tidak Boleh Kosong" : null,
                onChanged: (value) => setState(() => prodi = value.toString()),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Jenis Kelamin",
                style: TextStyle(fontSize: 16),
              ),
              RadioListTile(
                title: const Text("Pria"),
                value: "Pria",
                groupValue: jenKel,
                onChanged: (value) => setState(() => jenKel = value.toString()),
              ),
              RadioListTile(
                title: const Text("Wanita"),
                value: "Wanita",
                groupValue: jenKel,
                onChanged: (value) => setState(() => jenKel = value.toString()),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _simpan();
                    },
                    child: Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
