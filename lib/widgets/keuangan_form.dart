// lib/widgets/keuangan_form.dart
import 'package:flutter/material.dart';
import '../models/keuangan_model.dart';
import '../services/keuangan_service.dart';

class KeuanganForm extends StatefulWidget {
  final Keuangan? keuangan;
  final String userId;

  const KeuanganForm({Key? key, required this.userId, this.keuangan}) : super(key: key);

  @override
  KeuanganFormState createState() => KeuanganFormState();
}

class KeuanganFormState extends State<KeuanganForm> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  double _jumlah = 0.0;
  DateTime _tanggal = DateTime.now();
  String _tipe = 'Kas'; // Default tipe 'Kas'
  String _deskripsi = ''; // Tambahan properti 'deskripsi'

  @override
  void initState() {
    super.initState();
    if (widget.keuangan != null) {
      _nama = widget.keuangan!.nama;
      _jumlah = widget.keuangan!.jumlah;
      _tanggal = widget.keuangan!.tanggal;
      _tipe = widget.keuangan!.tipe;
      _deskripsi = widget.keuangan!.deskripsi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keuangan == null ? 'Tambah Keuangan' : 'Edit Keuangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _tipe,
                onChanged: (String? newValue) {
                  setState(() {
                    _tipe = newValue!;
                  });
                },
                items: <String>['Kas', 'Pengeluaran']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Tipe Transaksi'),
              ),
              TextFormField(
                initialValue: _nama,
                decoration: InputDecoration(
                  labelText: _tipe == 'Kas' ? 'Nama Pembayar' : 'Nama Pengeluar',
                ),
                onSaved: (value) => _nama = value!,
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                initialValue: _jumlah.toString(),
                decoration: const InputDecoration(labelText: 'Jumlah'),
                onSaved: (value) => _jumlah = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'Jumlah tidak boleh kosong' : null,
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Text(_tipe == 'Kas' ? 'Tanggal Pembayaran: ' : 'Tanggal Pengeluaran: '),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _tanggal,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _tanggal) {
                        setState(() {
                          _tanggal = pickedDate;
                        });
                      }
                    },
                    child: Text('${_tanggal.toLocal()}'.split(' ')[0]),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _deskripsi,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                onSaved: (value) => _deskripsi = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Keuangan keuangan = Keuangan(
                      id: widget.keuangan?.id ?? '',
                      userId: widget.userId,
                      nama: _nama,
                      jumlah: _jumlah,
                      tanggal: _tanggal,
                      tipe: _tipe,
                      deskripsi: _deskripsi,
                    );
                    KeuanganService keuanganService = KeuanganService(userId: widget.userId);
                    if (widget.keuangan == null) {
                      await keuanganService.tambahKeuangan(keuangan);
                    } else {
                      await keuanganService.editKeuangan(keuangan);
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
