import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/rental.dart';

class RentalsListPage extends StatefulWidget {
  @override
  _RentalsListPageState createState() => _RentalsListPageState();
}

class _RentalsListPageState extends State<RentalsListPage> {
  final _dbHelper = DatabaseHelper();
  List<Rental> _rentals = [];
  List<Rental> _filteredRentals = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRentals();
    _searchController.addListener(_filterRentals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRentals() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredRentals = _rentals.where((rental) {
        return rental.customerName.toLowerCase().contains(searchTerm) ||
               rental.contact.toLowerCase().contains(searchTerm) ||
               rental.rentalDate.toLowerCase().contains(searchTerm) ||
               (rental.returnDate?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();
    });
  }

  Future<void> _fetchRentals() async {
    final rentals = await _dbHelper.getRentals();
    setState(() {
      _rentals = rentals;
      _filteredRentals = rentals;
    });
  }

  Future<void> _addRental() async {
    final customerNameController = TextEditingController();
    final cameraIdController = TextEditingController();
    final rentalDateController = TextEditingController();
    final returnDateController = TextEditingController();
    final contactController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Rental Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextField(
                  controller: cameraIdController,
                  decoration: InputDecoration(labelText: 'ID Kamera'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: rentalDateController,
                  decoration:
                      InputDecoration(labelText: 'Tanggal Sewa (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: returnDateController,
                  decoration: InputDecoration(
                      labelText: 'Tanggal Kembali (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: 'Kontak'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (customerNameController.text.isEmpty ||
                    cameraIdController.text.isEmpty ||
                    rentalDateController.text.isEmpty ||
                    contactController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua kolom wajib diisi')),
                  );
                  return;
                }

                final newRental = Rental(
                  customerName: customerNameController.text,
                  cameraId: int.tryParse(cameraIdController.text) ?? 0,
                  rentalDate: rentalDateController.text,
                  returnDate: returnDateController.text,
                  contact: contactController.text,
                );
                await _dbHelper.insertRental(newRental);
                await _fetchRentals();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRental(Rental rental) async {
    final customerNameController =
        TextEditingController(text: rental.customerName);
    final cameraIdController =
        TextEditingController(text: rental.cameraId.toString());
    final rentalDateController = TextEditingController(text: rental.rentalDate);
    final returnDateController =
        TextEditingController(text: rental.returnDate ?? '');
    final contactController = TextEditingController(text: rental.contact);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Rental'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextField(
                  controller: cameraIdController,
                  decoration: InputDecoration(labelText: 'ID Kamera'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: rentalDateController,
                  decoration:
                      InputDecoration(labelText: 'Tanggal Sewa (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: returnDateController,
                  decoration: InputDecoration(
                      labelText: 'Tanggal Kembali (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: 'Kontak'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                rental.customerName = customerNameController.text;
                rental.cameraId =
                    int.tryParse(cameraIdController.text) ?? rental.cameraId;
                rental.rentalDate = rentalDateController.text;
                rental.returnDate = returnDateController.text;
                rental.contact = contactController.text;
                await _dbHelper.updateRental(rental);
                await _fetchRentals();
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRental(int id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus rental ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteRental(id);
                await _fetchRentals();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Rental'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari rental...',
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
              itemCount: _filteredRentals.length,
              itemBuilder: (context, index) {
                final rental = _filteredRentals[index];
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
                                rental.customerName,
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
                                  onPressed: () => _updateRental(rental),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteRental(rental.id!),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.camera_alt, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'ID Kamera: ${rental.cameraId}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              rental.contact,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'Tanggal Sewa: ${rental.rentalDate}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.assignment_return, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'Tanggal Kembali: ${rental.returnDate ?? "Belum dikembalikan"}',
                              style: TextStyle(
                                fontSize: 16,
                                color: rental.returnDate != null ? Colors.green[700] : Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
        onPressed: _addRental,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}