// lib/screens/peserta/peserta_list.dart

import 'package:flutter/material.dart';
import '../../db/database_helper.dart';
import '../../models/peserta.dart';
import 'add_edit_peserta.dart';

class PesertaList extends StatefulWidget {
  const PesertaList({super.key});

  @override
  _PesertaListState createState() => _PesertaListState();
}

class _PesertaListState extends State<PesertaList> {
  late Future<List<Peserta>> pesertaList;
  final dbHelper = DatabaseHelper();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    refreshPesertaList();
  }

  void refreshPesertaList() {
    setState(() {
      if (searchQuery == null || searchQuery!.isEmpty) {
        pesertaList = dbHelper.getPeserta();
      } else {
        pesertaList = dbHelper.searchPeserta(searchQuery!);
      }
    });
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearch = searchQuery ?? '';
        return AlertDialog(
          title: const Text('Cari Peserta'),
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
                refreshPesertaList();
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
  Future<void> _confirmDeletePeserta(int id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content:
            const Text('Apakah Anda yakin ingin menghapus peserta ini?'),
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
      await dbHelper.deletePeserta(id);
      refreshPesertaList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peserta berhasil dihapus')),
      );
    }
  }

  Widget buildPesertaItem(Peserta peserta) {
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
          peserta.nama,
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
              'Email: ${peserta.email}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'No. HP: ${peserta.noHp}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Alamat: ${peserta.alamat}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Jenis Kelamin: ${peserta.jenkel}',
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
                    builder: (context) => AddEditPeserta(peserta: peserta),
                  ),
                ).then((value) => refreshPesertaList());
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeletePeserta(peserta.id!),
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
          title: const Text('Data Peserta'),
          backgroundColor: Colors.greenAccent, // Warna header
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _openSearchDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Peserta>>(
                future: pesertaList,
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
                        Peserta peserta = snapshot.data![index];
                        return buildPesertaItem(peserta);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent, // Warna FAB
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditPeserta(),
              ),
            ).then((value) => refreshPesertaList());
          },
        ),
        backgroundColor: Colors.grey[100]); // Background soft
  }
}
