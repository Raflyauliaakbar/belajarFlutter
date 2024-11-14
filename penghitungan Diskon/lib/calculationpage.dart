import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  // Variabel untuk input dan hasil
  double hargaBarang = 0;
  double diskonPersen = 0;
  double jumlahDiskon = 0;
  double hargaSetelahDiskon = 0;

  // Fungsi untuk menghitung diskon
  void hitungDiskon() {
    setState(() {
      // Menghitung jumlah diskon dalam rupiah
      jumlahDiskon = hargaBarang * (diskonPersen / 100);
      // Menghitung harga setelah diskon
      hargaSetelahDiskon = hargaBarang - jumlahDiskon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perhitungan Diskon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Input Harga Barang
            TextField(
              decoration: InputDecoration(
                labelText: 'Harga Barang',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                hargaBarang = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),

            // Input Diskon (%)
            TextField(
              decoration: InputDecoration(
                labelText: 'Diskon (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                diskonPersen = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),

            // Tombol Hitung
            ElevatedButton(
              onPressed: hitungDiskon,
              child: Text('Hitung'),
            ),
            SizedBox(height: 30),

            // Menampilkan hasil dalam kotak seperti inputan
            TextField(
              decoration: InputDecoration(
                labelText: 'Jumlah Diskon (Rp.)',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: jumlahDiskon.toStringAsFixed(0),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                labelText: 'Harga Setelah Diskon',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: hargaSetelahDiskon.toStringAsFixed(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
