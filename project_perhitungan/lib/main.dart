import 'package:flutter/material.dart';
import 'package:project_perhitungan/beranda.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BerandaPage(), // Corrected syntax error by replacing ; with ,
    );
  }
}
