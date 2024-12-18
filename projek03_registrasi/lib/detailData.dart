import 'package:flutter/material.dart';
import 'package:projek03_registrasi/mahasiswa.dart';

class DetailData extends StatelessWidget {
  final Mahasiswa mhs;
  DetailData({required this.mhs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Data Mahasiswa"),
          backgroundColor: Colors.green.shade500,
          centerTitle: true,
        ),
        body: Center( 
          child: Column(
            children: [
              Text("NPM : " + mhs.npm),
              Text("Nama : " + mhs.namaLengkap),
              Text("Prodi : " + mhs.prodi),
              Text("Jenis Kelamin : " + mhs.jenkel),
            ],
          ),
        ));
  }
}
