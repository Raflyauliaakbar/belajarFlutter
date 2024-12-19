import 'package:flutter/material.dart';
import 'kursus/kursus_list.dart';
import 'peserta/peserta_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembaga Kursus'),
        backgroundColor: Colors.blueAccent, // Warna header
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: const Text('Data Kursus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Warna tombol
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KursusList()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Data Peserta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Warna tombol
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PesertaList()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100], // Background soft
    );
  }
}
