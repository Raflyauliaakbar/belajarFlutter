import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const JadwalKajianApp());
}

class JadwalKajianApp extends StatelessWidget {
  const JadwalKajianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Program Jadwal Kajian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
