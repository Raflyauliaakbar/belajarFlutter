import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  double jariJari = 0;
  double luasLingkaran = 0;
  double kelilingLingkaran = 0;

  void hitungLingkaran() {
    setState(() {
      const double pi = 3.14;
      luasLingkaran = pi * jariJari * jariJari;
      kelilingLingkaran = 2 * pi * jariJari;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perhitungan Lingkaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Input Jari-jari Lingkaran
            TextField(
              decoration: InputDecoration(
                labelText: 'Nilai Jari-jari Lingkaran',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                jariJari = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: hitungLingkaran,
              child: Text('Hitung'),
            ),
            SizedBox(height: 30),

            // Output Luas Lingkaran
            TextField(
              decoration: InputDecoration(
                labelText: 'Luas Lingkaran',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: luasLingkaran.toStringAsFixed(2),
              ),
            ),
            SizedBox(height: 20),

            // Output Keliling Lingkaran
            TextField(
              decoration: InputDecoration(
                labelText: 'Keliling Lingkaran',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: kelilingLingkaran.toStringAsFixed(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
