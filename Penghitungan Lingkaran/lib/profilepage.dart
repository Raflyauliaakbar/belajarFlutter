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
            // Menampilkan Foto Profil
            CircleAvatar(
  radius: 50,
  backgroundImage: AssetImage('assets/foto.jpg'),
  backgroundColor: Colors.grey[200],
)
,
            SizedBox(height: 20),

            // Menampilkan informasi tambahan tentang profil
            Text(
              'Nama: Nama Mahasiswa',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'NPM: 2210010127',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
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
