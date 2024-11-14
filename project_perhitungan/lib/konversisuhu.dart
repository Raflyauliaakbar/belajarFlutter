import 'package:flutter/material.dart';

class Konversisuhu extends StatefulWidget {
  const Konversisuhu({super.key});

  @override
  _KonversisuhuState createState() => _KonversisuhuState();
}

class _KonversisuhuState extends State<Konversisuhu> {
  final TextEditingController _fahrenheitController = TextEditingController();
  double? _celsius;
  double? _kelvin;
  double? _reamur;

  void _convertTemperature() {
    setState(() {
      double fahrenheit = double.tryParse(_fahrenheitController.text) ?? 0;
      _celsius = (fahrenheit - 32) * 5 / 9;
      _kelvin = _celsius! + 273.15;
      _reamur = _celsius! * 4 / 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konversi Suhu dari Fahrenheit"),
        backgroundColor: Colors.cyan.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fahrenheitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan suhu dalam Fahrenheit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade400,
              ),
              child: const Text("Konversi"),
            ),
            const SizedBox(height: 16),
            if (_celsius != null)
              Text(
                "Celsius: ${_celsius!.toStringAsFixed(2)} °C",
                style: const TextStyle(fontSize: 16),
              ),
            if (_kelvin != null)
              Text(
                "Kelvin: ${_kelvin!.toStringAsFixed(2)} K",
                style: const TextStyle(fontSize: 16),
              ),
            if (_reamur != null)
              Text(
                "Reamur: ${_reamur!.toStringAsFixed(2)} °Re",
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Konversisuhu(),
  ));
}
