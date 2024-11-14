import 'package:flutter/material.dart';
import 'package:project_perhitungan/operasiduabilangan.dart';
import 'package:project_perhitungan/konversisuhu.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Perhitungan"),
        backgroundColor: Colors.cyan.shade400,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Silahkan pilih menu yang tersedia:"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Operasiduabilangan()));
                },
                child: const Text("Operasi 2 Bilangan")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Konversisuhu()));
              },
              child: const Text("Konversi Suhu"),
            ),
          ],
        ),
      ),
    );
  }
}
