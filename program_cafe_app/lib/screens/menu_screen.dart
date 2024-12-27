import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/menu.dart';
import '../utils.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Menu> _menus = [];
  List<Menu> _filteredMenus = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshMenus();
    _searchController.addListener(_searchMenus);
  }

  void _refreshMenus() async {
    List<Menu> x = await _dbHelper.getMenus();
    setState(() {
      _menus = x;
      _filteredMenus = x;
    });
  }

  void _searchMenus() {
    String keyword = _searchController.text;
    if (keyword.isEmpty) {
      setState(() {
        _filteredMenus = _menus;
      });
    } else {
      setState(() {
        _filteredMenus = _menus
            .where((menu) =>
                menu.name.toLowerCase().contains(keyword.toLowerCase()) ||
                menu.category.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  void _showForm({Menu? menu}) {
    final _formKey = GlobalKey<FormState>();
    String name = menu?.name ?? '';
    String description = menu?.description ?? '';
    String price = menu != null ? menu.price.toString() : '';
    String category = menu?.category ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(menu == null ? 'Tambah Menu' : 'Edit Menu'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) =>
                        value!.isEmpty ? 'Tolong masukkan nama' : null,
                    onSaved: (value) => name = value!,
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    onSaved: (value) => description = value ?? '',
                  ),
                  TextFormField(
                    initialValue: price,
                    decoration: const InputDecoration(labelText: 'Harga (dalam angka)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Tolong masukkan harga' : null,
                    onSaved: (value) => price = value!,
                  ),
                  TextFormField(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    onSaved: (value) => category = value ?? '',
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
                  if (menu == null) {
                    await _dbHelper.insertMenu(Menu(
                      name: name,
                      description: description,
                      price: double.parse(price),
                      category: category,
                    ));
                  } else {
                    await _dbHelper.updateMenu(Menu(
                      id: menu.id,
                      name: name,
                      description: description,
                      price: double.parse(price),
                      category: category,
                    ));
                  }
                  _refreshMenus();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteMenu(int id) async {
    await _dbHelper.deleteMenu(id);
    _refreshMenus();
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchMenus);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari Menu...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredMenus.length,
        itemBuilder: (context, index) {
          final menu = _filteredMenus[index];
          return ListTile(
            title: Text(menu.name),
            subtitle: Text('${menu.category} - ${formatRupiah(menu.price)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showForm(menu: menu),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMenu(menu.id!),
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
