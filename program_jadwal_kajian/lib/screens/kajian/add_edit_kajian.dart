import 'package:flutter/material.dart';
import '../../db/dbhelper.dart';
import '../../models/kajian.dart';

class AddEditKajian extends StatefulWidget {
  final Kajian? kajian;

  const AddEditKajian({super.key, this.kajian});

  @override
  _AddEditKajianState createState() => _AddEditKajianState();
}

class _AddEditKajianState extends State<AddEditKajian> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = DBHelper.instance;

  late String namaKajian;
  late String pembicara;
  late String hariTanggal;
  late String tempatAcara;
  String? kategori;

  // Daftar Kategori Kajian
  final List<String> _kategoriList = [
    'Umum',
    'Khusus',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    namaKajian = widget.kajian?.namaKajian ?? '';
    pembicara = widget.kajian?.pembicara ?? '';
    hariTanggal = widget.kajian?.hariTanggal ?? '';
    tempatAcara = widget.kajian?.tempatAcara ?? '';
    kategori = widget.kajian?.kategori ?? 'Umum';
  }

  void _saveKajian() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Kajian kajian = Kajian(
        id: widget.kajian?.id,
        namaKajian: namaKajian,
        pembicara: pembicara,
        hariTanggal: hariTanggal,
        tempatAcara: tempatAcara,
        kategori: kategori!,
      );

      if (widget.kajian == null) {
        await dbHelper.insertKajian(kajian);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal Kajian berhasil ditambahkan')),
        );
      } else {
        await dbHelper.updateKajian(kajian);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal Kajian berhasil diperbarui')),
        );
      }

      Navigator.pop(context);
    }
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: kategori,
        decoration: const InputDecoration(
          labelText: 'Kategori',
          border: OutlineInputBorder(),
        ),
        items: _kategoriList
            .map((kategoriItem) => DropdownMenuItem(
                  value: kategoriItem,
                  child: Text(kategoriItem),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            kategori = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Kategori tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  // Implementasi DatePicker dan TimePicker untuk hariTanggal
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hariTanggal = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        hariTanggal += ' ${picked.format(context)}';
      });
    }
  }

  Widget _buildDateTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? 'Pilih Tanggal'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
              onPressed: () => _selectDate(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(
                selectedTime == null
                    ? 'Pilih Waktu'
                    : selectedTime!.format(context),
              ),
              onPressed: () => _selectTime(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jika widget.kajian sudah diisi, kita juga harus mengisi selectedDate dan selectedTime
    if (widget.kajian != null) {
      List<String> parts = widget.kajian!.hariTanggal.split(' ');
      if (parts.length >= 2) {
        // Parsing tanggal
        try {
          List<String> dateParts = parts[1].split('/');
          if (dateParts.length == 3) {
            selectedDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
          }
        } catch (e) {
          // Handle parsing error jika format salah
        }
        // Parsing waktu
        if (parts.length >= 3) {
          try {
            TimeOfDay parsedTime = TimeOfDay(
              hour: int.parse(parts[2].split(':')[0]),
              minute: int.parse(parts[2].split(':')[1]),
            );
            selectedTime = parsedTime;
          } catch (e) {
            // Handle parsing error jika format salah
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kajian == null ? 'Tambah Jadwal Kajian' : 'Edit Jadwal Kajian'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Nama Kajian',
                initialValue: namaKajian,
                onSaved: (value) => namaKajian = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kajian tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Pembicara',
                initialValue: pembicara,
                onSaved: (value) => pembicara = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pembicara tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildDateTimePicker(),
              _buildDropdownField(),
              _buildTextField(
                label: 'Tempat Acara',
                initialValue: tempatAcara,
                onSaved: (value) => tempatAcara = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tempat acara tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveKajian,
                child: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
