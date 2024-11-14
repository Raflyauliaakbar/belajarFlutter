import 'package:flutter/material.dart';

TextEditingController bil1 = TextEditingController();
TextEditingController bil2 = TextEditingController();
TextEditingController hasil = TextEditingController();

class Operasiduabilangan extends StatelessWidget {
  const Operasiduabilangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Operasi 2 Bilangan"),
        backgroundColor: Colors.cyan.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: bil1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Input Bilangan Pertama",
                  labelText: "Input Bilangan Pertama",
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: bil2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Input Bilangan Kedua",
                  labelText: "Input Bilangan Kedua",
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      double hitung =
                          double.parse(bil1.text) + double.parse(bil2.text);
                      hasil.text = hitung.toString();
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bil1.clear();
                      bil2.clear();
                      hasil.clear();
                    },
                    child: const Text("Clear"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: hasil,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Hasil Perhitungan",
                  labelText: "Hasil Perhitungan",
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
