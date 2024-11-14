import 'package:flutter/material.dart';
import 'calculationpage.dart';
import 'profilepage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan Nomor Absen
              Text(
                'Nomor Absen: 10',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              // Tombol Navigasi ke Halaman Perhitungan
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalculationPage()),
                  );
                },
                child: Text('Halaman Perhitungan Lingkaran'),
              ),
              SizedBox(height: 20),

              // Tombol Navigasi ke Halaman Profil
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Text('Halaman Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
