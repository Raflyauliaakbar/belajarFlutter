import 'package:flutter/material.dart';
import 'package:projek03_registrasi/dbhelper.dart';
import 'package:projek03_registrasi/detailData.dart';
import 'package:projek03_registrasi/mahasiswa.dart';
import 'package:projek03_registrasi/register.dart';
import 'package:projek03_registrasi/edit.dart';

class ReviewData extends StatefulWidget {
  const ReviewData({Key? key}) : super(key: key);

  @override
  State<ReviewData> createState() => _ReviewDataState();
}

class _ReviewDataState extends State<ReviewData> {
  final Dbhelper dbhelper = Dbhelper();
  List<Mahasiswa> mhs = [];
  bool cariData = false; // Status pencarian aktif/tidak
  final TextEditingController nilaiCari = TextEditingController(); // Controller untuk input pencarian

  @override
  void initState() {
    super.initState();
    _refreshDataMahasiswa();
  }

  // Fungsi untuk mengambil data mahasiswa dari database
  Future<void> _refreshDataMahasiswa({String? query}) async {
    List<Mahasiswa> mahasiswa = await dbhelper.getMahasiswa(query: query);
    setState(() {
      mhs = mahasiswa;
    });
  }

  // Fungsi untuk menghapus data mahasiswa
  void _hapusData(String npm) async {
    await dbhelper.deleteMahasiswa(npm);
    _refreshDataMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: cariData
            ? TextField(
                controller: nilaiCari,
                decoration: const InputDecoration(
                  hintText: "Cari Nama Mahasiswa...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => _refreshDataMahasiswa(query: value),
              )
            : const Text("Data Mahasiswa"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(cariData ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                cariData = !cariData;
                if (!cariData) {
                  nilaiCari.clear();
                  _refreshDataMahasiswa();
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageRegistrasi()),
          );
          _refreshDataMahasiswa();
        },
        child: const Icon(Icons.add),
      ),
      body: mhs.isEmpty
          ? const Center(child: Text('Data Mahasiswa Kosong'))
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: mhs.length,
              itemBuilder: (context, index) {
                final dataMhs = mhs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      dataMhs.npm.substring(0, 2), // Inisial NPM
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(dataMhs.namaLengkap),
                  subtitle: Text("Prodi: ${dataMhs.prodi}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPage(mahasiswa: dataMhs),
                            ),
                          );
                          if (result == true) {
                            _refreshDataMahasiswa();
                          }
                        },
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Data'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus data ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _hapusData(dataMhs.npm);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailData(mhs: dataMhs),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
