// lib/screens/kajian/kajian_list.dart

import 'package:flutter/material.dart';
import '../../db/dbhelper.dart';
import '../../models/kajian.dart';
import 'add_edit_kajian.dart';
import '../topik_kajian/topik_kajian_list.dart';

class KajianList extends StatefulWidget {
  const KajianList({super.key});

  @override
  _KajianListState createState() => _KajianListState();
}

class _KajianListState extends State<KajianList> {
  final DBHelper dbHelper = DBHelper.instance;
  late Future<List<Kajian>> kajianList;
  String? selectedKategori;
  String? searchQuery;

  // Daftar Kategori Kajian
  final List<String> _kategoriList = [
    'Semua',
    'Kajian',
    'Ceramah',
    'Khusus',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    refreshKajianList();
  }

  void refreshKajianList() {
    setState(() {
      if ((searchQuery == null || searchQuery!.isEmpty) &&
          (selectedKategori == null || selectedKategori == 'Semua')) {
        kajianList = dbHelper.getAllKajian();
      } else if ((searchQuery == null || searchQuery!.isEmpty) &&
          selectedKategori != 'Semua') {
        kajianList = dbHelper.getAllKajian().then((list) => list
            .where((kajian) =>
                kajian.kategori.toLowerCase() ==
                selectedKategori!.toLowerCase())
            .toList());
      } else if (searchQuery != null && searchQuery!.isNotEmpty) {
        kajianList = dbHelper.getAllKajian().then((list) => list
            .where((kajian) =>
                kajian.namaKajian
                    .toLowerCase()
                    .contains(searchQuery!.toLowerCase()) ||
                kajian.pembicara
                    .toLowerCase()
                    .contains(searchQuery!.toLowerCase()) ||
                kajian.kategori
                    .toLowerCase()
                    .contains(searchQuery!.toLowerCase()))
            .toList());
      } else {
        kajianList = dbHelper.getAllKajian();
      }
    });
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearch = searchQuery ?? '';
        return AlertDialog(
          title: const Text('Cari Jadwal Kajian'),
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
                refreshKajianList();
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
  Future<void> _confirmDeleteJadwalKajian(int id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content:
            const Text('Apakah Anda yakin ingin menghapus jadwal kajian ini?'),
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
      await dbHelper.deleteKajian(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal Kajian berhasil dihapus')),
      );
      refreshKajianList();
    }
  }

  Widget buildKajianItem(Kajian kajian) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        title: Text(kajian.namaKajian),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pembicara: ${kajian.pembicara}'),
            Text('Hari, Tanggal: ${kajian.hariTanggal}'),
            Text('Tempat Acara: ${kajian.tempatAcara}'),
            Text('Kategori: ${kajian.kategori}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.topic, color: Colors.blue),
              tooltip: 'Topik Kajian',
              onPressed: () => _navigateToTopikKajian(kajian.id!),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: 'Edit Kajian',
              onPressed: () => _navigateToEditKajian(kajian),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus Kajian',
              onPressed: () => _confirmDeleteJadwalKajian(kajian.id!),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddKajian() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditKajian()),
    ).then((_) {
      refreshKajianList();
    });
  }

  void _navigateToEditKajian(Kajian kajian) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditKajian(kajian: kajian)),
    ).then((_) {
      refreshKajianList();
    });
  }

  void _navigateToTopikKajian(int jadwalKajianId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TopikKajianList(jadwalKajianId: jadwalKajianId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kajian'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearchDialog,
            tooltip: 'Cari Jadwal Kajian',
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown untuk filter kategori
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
                  refreshKajianList();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Kajian>>(
              future: kajianList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child:
                        Text('Tidak ada jadwal kajian. Tambahkan jadwal baru!'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Kajian kajian = snapshot.data![index];
                      return buildKajianItem(kajian);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddKajian,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Jadwal Kajian',
      ),
    );
  }
}
