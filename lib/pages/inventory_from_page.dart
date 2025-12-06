import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/inventory.dart';

class InventoryFormPage extends StatefulWidget {
  final Inventory? inventory;

  const InventoryFormPage({super.key, this.inventory});

  @override
  State<InventoryFormPage> createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends State<InventoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  final _hargaC = TextEditingController();
  final _jumlahC = TextEditingController();
  final _tanggalC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.inventory != null) {
      _namaC.text = widget.inventory!.nama;
      _hargaC.text = widget.inventory!.harga.toString();
      _jumlahC.text = widget.inventory!.jumlah.toString();
      _tanggalC.text = widget.inventory!.tanggalMasuk;
    } else {
      _tanggalC.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _tanggalC.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final inv = Inventory(
      id: widget.inventory?.id ?? 0,
      nama: _namaC.text.trim(),
      harga: int.tryParse(_hargaC.text.trim()) ?? 0,
      jumlah: int.tryParse(_jumlahC.text.trim()) ?? 0,
      tanggalMasuk: _tanggalC.text.trim(),
    );

    Navigator.pop(context, inv);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.inventory != null;
    const gradientTop = Color(0xFF757575);    // grey 600
    const gradientBottom = Color(0xFF212121); // grey 900

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Inventaris Adelmart'
              : 'Tambah Inventaris Adelmart',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientTop, gradientBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isEdit ? 'Perbarui Data Barang' : 'Input Data Barang',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lengkapi informasi barang inventaris komputer Adelmart.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _namaC,
                          decoration: const InputDecoration(
                            labelText: 'Nama Barang',
                            prefixIcon: Icon(Icons.devices_other_outlined),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _hargaC,
                          decoration: const InputDecoration(
                            labelText: 'Harga (Rp)',
                            prefixIcon: Icon(Icons.price_change_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _jumlahC,
                          decoration: const InputDecoration(
                            labelText: 'Jumlah',
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Jumlah wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _tanggalC,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Masuk (yyyy-MM-dd)',
                            prefixIcon:
                                const Icon(Icons.calendar_today_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: _pickDate,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
