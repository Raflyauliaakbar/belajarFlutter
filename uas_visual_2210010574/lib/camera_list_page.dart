import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'models/camera.dart';

class CameraListPage extends StatefulWidget {
  @override
  _CameraListPageState createState() => _CameraListPageState();
}

class _CameraListPageState extends State<CameraListPage> {
  final _dbHelper = DatabaseHelper();
  List<Camera> _cameras = [];
  List<Camera> _filteredCameras = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCameras();
    _searchController.addListener(_filterCameras);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCameras() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredCameras = _cameras.where((camera) {
        return camera.name.toLowerCase().contains(searchTerm) ||
            camera.brand.toLowerCase().contains(searchTerm) ||
            (camera.description?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();
    });
  }

  Future<void> _fetchCameras() async {
    final cameras = await _dbHelper.getCameras();
    setState(() {
      _cameras = cameras;
      _filteredCameras = cameras;
    });
  }

  Future<void> _addCamera() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController brandController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kamera Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Kamera'),
              ),
              TextField(
                controller: brandController,
                decoration: InputDecoration(labelText: 'Merek Kamera'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga (Rupiah)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final newCamera = Camera(
                  name: nameController.text,
                  brand: brandController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  status: 'Tersedia',
                  description: descriptionController.text,
                );
                await _dbHelper.insertCamera(newCamera);
                _fetchCameras();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCamera(Camera camera) async {
    TextEditingController nameController =
        TextEditingController(text: camera.name);
    TextEditingController brandController =
        TextEditingController(text: camera.brand);
    TextEditingController priceController =
        TextEditingController(text: camera.price.toString());
    TextEditingController descriptionController =
        TextEditingController(text: camera.description ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kamera'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Kamera'),
              ),
              TextField(
                controller: brandController,
                decoration: InputDecoration(labelText: 'Merek Kamera'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga (Rupiah)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                camera.name = nameController.text;
                camera.brand = brandController.text;
                camera.price =
                    double.tryParse(priceController.text) ?? camera.price;
                camera.description = descriptionController.text;
                await _dbHelper.updateCamera(camera);
                _fetchCameras();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCamera(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus kamera ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteCamera(id);
                _fetchCameras();
                Navigator.pop(context);
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Kamera'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kamera...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredCameras.length,
              itemBuilder: (context, index) {
                final camera = _filteredCameras[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                camera.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _updateCamera(camera),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCamera(camera.id!),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.camera_alt,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              camera.brand,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.attach_money,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              formatCurrency.format(camera.price),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (camera.description != null &&
                            camera.description!.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.description,
                                  size: 16, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deskripsi:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      camera.description!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCamera,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
