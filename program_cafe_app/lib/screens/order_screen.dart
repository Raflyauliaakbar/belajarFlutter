import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/order.dart';
import '../models/menu.dart';
import '../utils.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  List<Menu> _menus = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshOrders();
    _loadMenus();
    _searchController.addListener(_searchOrders);
  }

  void _refreshOrders() async {
    List<Order> x = await _dbHelper.getOrders();
    setState(() {
      _orders = x;
      _filteredOrders = x;
    });
  }

  void _loadMenus() async {
    List<Menu> x = await _dbHelper.getMenus();
    setState(() {
      _menus = x;
    });
  }

  void _searchOrders() {
    String keyword = _searchController.text;
    if (keyword.isEmpty) {
      setState(() {
        _filteredOrders = _orders;
      });
    } else {
      setState(() {
        _filteredOrders =
            _orders.where((order) => order.date.contains(keyword)).toList();
      });
    }
  }

  void _showForm({Order? order}) {
    final _formKey = GlobalKey<FormState>();
    int menuId = order?.menuId ?? (_menus.isNotEmpty ? _menus[0].id! : 0);
    int quantity = order?.quantity ?? 1;
    String date =
        order?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(order == null ? 'Tambah Pesanan' : 'Ubah Pesanan'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: menuId,
                    decoration: const InputDecoration(labelText: 'Menu'),
                    items: _menus.map((menu) {
                      return DropdownMenuItem<int>(
                        value: menu.id,
                        child: Text(menu.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        menuId = value!;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: quantity.toString(),
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Tolong masukkan jumlah' : null,
                    onSaved: (value) => quantity = int.parse(value!),
                  ),
                  TextFormField(
                    initialValue: date,
                    decoration: const InputDecoration(labelText: 'Tanggal'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(date) ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          date = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Tolong masukkan tanggal' : null,
                    onSaved: (value) => date = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  double price =
                      _menus.firstWhere((menu) => menu.id == menuId).price;
                  double totalPrice = price * quantity;

                  if (order == null) {
                    await _dbHelper.insertOrder(Order(
                      menuId: menuId,
                      quantity: quantity,
                      totalPrice: totalPrice,
                      date: date,
                    ));
                  } else {
                    await _dbHelper.updateOrder(Order(
                      id: order.id,
                      menuId: menuId,
                      quantity: quantity,
                      totalPrice: totalPrice,
                      date: date,
                    ));
                  }
                  _refreshOrders();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(int id) async {
    await _dbHelper.deleteOrder(id);
    _refreshOrders();
  }

  String _getMenuName(int menuId) {
    try {
      return _menus.firstWhere((menu) => menu.id == menuId).name;
    } catch (e) {
      return 'Tidak Diketahui';
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchOrders);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari berdasarkan tanggal...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return ListTile(
            title: Text(_getMenuName(order.menuId)),
            subtitle: Text(
                'Jumlah: ${order.quantity} | Total: ${formatRupiah(order.totalPrice)} | Tanggal: ${order.date}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showForm(order: order),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteOrder(order.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }
}
