import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/assets/foto.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Nama: M.RAFLY AULIA AKBAR',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'NPM: 2210010574',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Program Studi: Teknik Informatika',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
