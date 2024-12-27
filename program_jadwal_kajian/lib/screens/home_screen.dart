// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'kajian/kajian_list.dart';
import 'topik_kajian/topik_kajian_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Jadwal Kajian'),
        backgroundColor: Colors.blueAccent, // Warna header
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.event),
                label: const Text('Jadwal Kajian'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Warna tombol
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KajianList()),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.topic),
                label: const Text('Topik Kajian'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Warna tombol
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Pastikan Anda memiliki `jadwalKajianId` yang valid
                  // Untuk contoh ini, kita menggunakan jadwalKajianId = 1
                  // Anda dapat mengubahnya sesuai kebutuhan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopikKajianList(jadwalKajianId: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Background soft
    );
  }
}
