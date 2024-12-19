// lib/screens/kursus/kursus_list.dart

import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/kursus.dart';
import 'add_edit_kursus.dart';

class KursusList extends StatefulWidget {
  const KursusList({super.key});

  @override
  _KursusListState createState() => _KursusListState();
}

class _KursusListState extends State<KursusList> {
  late Future<List<Kursus>> kursusList;
  final dbHelper = DatabaseHelper();
  String? selectedKategori;
  String? searchQuery;

  // Daftar Kategori IT
  final List<String> _kategoriList = [
    'Semua',
    'Koding',
    'Desain Grafis',
    'Jaringan',
    'Keamanan Siber',
    'Pengembangan Mobile',
    'Database',
    'Cloud Computing',
    'AI & Machine Learning',
    'UI/UX Design',
    'DevOps',
  ];

  @override
  void initState() {
    super.initState();
    refreshKursusList();
  }

  void refreshKursusList() {
    setState(() {
      if ((searchQuery == null || searchQuery!.isEmpty) &&
          (selectedKategori == null || selectedKategori == 'Semua')) {
        kursusList = dbHelper.getKursus();
      } else if ((searchQuery == null || searchQuery!.isEmpty) &&
          selectedKategori != 'Semua') {
        kursusList = dbHelper.searchKursusByKategori(selectedKategori!);
      } else if (searchQuery != null &&
          searchQuery!.isNotEmpty &&
          (selectedKategori == null || selectedKategori == 'Semua')) {
        kursusList = dbHelper.searchKursus(searchQuery!);
      } else {
        kursusList = dbHelper.searchKursusWithKategori(
            searchQuery!, selectedKategori!);
      }
    });
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearch = searchQuery ?? '';
        return AlertDialog(
          title: const Text('Cari Kursus'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Masukkan kata kunci'),
            onChanged: (value) {
              tempSearch = value;
            },
            controller: TextEditingController(text: tempSearch),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  searchQuery = tempSearch;
                });
                refreshKursusList();
                Navigator.pop(context);
              },
              child: const Text('Cari'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  Future<void> _confirmDeleteKursus(int id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus kursus ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != null && confirm) {
      await dbHelper.deleteKursus(id);
      refreshKursusList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kursus berhasil dihapus')),
      );
    }
  }

  Widget buildKursusItem(Kursus kursus) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          kursus.nama,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Instruktur: ${kursus.instruktur}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Jadwal: ${kursus.jadwal}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Lokasi: ${kursus.lokasi}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Kategori: ${kursus.kategori}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditKursus(kursus: kursus),
                  ),
                ).then((value) => refreshKursusList());
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteKursus(kursus.id!),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Kursus'),
          backgroundColor: Colors.blueAccent, // Warna header
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _openSearchDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: selectedKategori ?? 'Semua',
                decoration: const InputDecoration(
                  labelText: 'Filter Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _kategoriList
                    .map((kategori) => DropdownMenuItem(
                          value: kategori,
                          child: Text(kategori),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                    refreshKursusList();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Kursus>>(
                future: kursusList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Kursus kursus = snapshot.data![index];
                        return buildKursusItem(kursus);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent, // Warna FAB
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditKursus(),
              ),
            ).then((value) => refreshKursusList());
          },
        ),
        backgroundColor: Colors.grey[100]); // Background soft
  }
}
