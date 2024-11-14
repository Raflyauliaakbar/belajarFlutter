import 'package:flutter/material.dart';

void main() {
  runApp(const HelloWorld());
}

class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hello World",
      home: const BerandaPage(),
    );
  }
}

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30,
        shadowColor: const Color.fromARGB(255, 233, 222, 222),
        backgroundColor: const Color.fromARGB(255, 79, 102, 140),
        title: const Text("Halaman Utama"),
        centerTitle: true,
        leading: const Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(3),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Biodata Diri",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Nama : M.Rafly Aulia Akbar\nNPM : 2210010574\nKelas : 5b\nTahun Angkatan : 2022",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tombol("Beranda", Icons.home, Colors.purple, context,
                    const ProfilePage()),
                tombol("Profile", Icons.account_circle, Colors.cyan, context,
                    const ProfilePage()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tombol("KRS", Icons.edit, Colors.orange, context, KRSPage()),
                tombol("KHS", Icons.book, Colors.green, context,
                    KRSPage()), // Update this to the correct page if needed
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tombol("Jadwal", Icons.calendar_month, Colors.red, context,
                    KRSPage()), // Update this to the correct page if needed
                tombol("Pembayaran", Icons.payment, Colors.blue, context,
                    KRSPage()), // Update this to the correct page if needed
              ],
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
        ],
      ),
    );
  }
}

Widget tombol(String judul, IconData iconTombol, Color warna,
    BuildContext context, Widget link) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => link),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(25),
      ),
      width: 104,
      height: 104,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconTombol, size: 52, color: Colors.white),
          Text(
            judul,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Profile Page!'),
      ),
    );
  }
}

class KRSPage extends StatelessWidget {
  KRSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KRS Page'),
      ),
      body: const Center(
        child: Text('Welcome to the KRS Page!'),
      ),
    );
  }
}
