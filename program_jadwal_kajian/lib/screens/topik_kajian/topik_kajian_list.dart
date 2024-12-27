// lib/screens/topik_kajian/topik_kajian_list.dart

import 'package:flutter/material.dart';
import '../../db/dbhelper.dart';
import '../../models/topik_kajian.dart';
import 'add_edit_topik_kajian.dart';

class TopikKajianList extends StatefulWidget {
  final int jadwalKajianId;

  const TopikKajianList({super.key, required this.jadwalKajianId});

  @override
  _TopikKajianListState createState() => _TopikKajianListState();
}

class _TopikKajianListState extends State<TopikKajianList> {
  final DBHelper dbHelper = DBHelper.instance;
  late Future<List<TopikKajian>> topikKajianList;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    refreshTopikKajianList();
  }

  void refreshTopikKajianList() {
    setState(() {
      topikKajianList = dbHelper.getTopikKajian(widget.jadwalKajianId);
    });
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearch = searchQuery ?? '';
        return AlertDialog(
          title: const Text('Cari Topik Kajian'),
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
                _searchTopikKajian();
                Navigator.pop(context);
              },
              child: const Text('Cari'),
            ),
          ],
        );
      },
    );
  }

  void _searchTopikKajian() {
    setState(() {
      if (searchQuery == null || searchQuery!.isEmpty) {
        topikKajianList = dbHelper.getTopikKajian(widget.jadwalKajianId);
      } else {
        topikKajianList = dbHelper.getTopikKajian(widget.jadwalKajianId).then(
              (list) => list
                  .where((topik) =>
                      topik.topikNama
                          .toLowerCase()
                          .contains(searchQuery!.toLowerCase()) ||
                      topik.deskripsi
                          .toLowerCase()
                          .contains(searchQuery!.toLowerCase()) ||
                      topik.materi
                          .toLowerCase()
                          .contains(searchQuery!.toLowerCase()))
                  .toList(),
            );
      }
    });
  }

  Future<void> _confirmDeleteTopikKajian(int id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus topik kajian ini?'),
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
      await dbHelper.deleteTopikKajian(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topik Kajian berhasil dihapus')),
      );
      refreshTopikKajianList();
    }
  }

  Widget buildTopikKajianItem(TopikKajian topikKajian) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        title: Text(topikKajian.topikNama),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deskripsi: ${topikKajian.deskripsi}'),
            Text('Materi: ${topikKajian.materi}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: 'Edit Topik Kajian',
              onPressed: () => _navigateToEditTopikKajian(topikKajian),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus Topik Kajian',
              onPressed: () => _confirmDeleteTopikKajian(topikKajian.id!),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTopikKajian() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditTopikKajian(
                jadwalKajianId: widget.jadwalKajianId,
              )),
    ).then((_) {
      refreshTopikKajianList();
    });
  }

  void _navigateToEditTopikKajian(TopikKajian topikKajian) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditTopikKajian(topikKajian: topikKajian)),
    ).then((_) {
      refreshTopikKajianList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topik Kajian'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearchDialog,
            tooltip: 'Cari Topik Kajian',
          ),
        ],
      ),
      body: FutureBuilder<List<TopikKajian>>(
        future: topikKajianList,
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
              child: Text('Tidak ada topik kajian. Tambahkan topik baru!'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TopikKajian topikKajian = snapshot.data![index];
                return buildTopikKajianItem(topikKajian);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTopikKajian,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Topik Kajian',
      ),
    );
  }
}
