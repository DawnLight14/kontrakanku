// lib/widgets/jadwal_form.dart
import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';
import '../services/jadwal_service.dart';

class JadwalForm extends StatefulWidget {
  final Jadwal? jadwal;
  final String userId;

  JadwalForm({required this.userId, this.jadwal});

  @override
  _JadwalFormState createState() => _JadwalFormState();
}

class _JadwalFormState extends State<JadwalForm> {
  final _formKey = GlobalKey<FormState>();
  late String _deskripsi;
  late DateTime _tanggalSewa;
  late String _namaPenghuni;
  late double _jumlahBayar;
  late bool _pengulanganBulanan;

  @override
  void initState() {
    super.initState();
    _deskripsi = widget.jadwal?.deskripsi ?? '';
    _tanggalSewa = widget.jadwal?.tanggalMulai ?? DateTime.now();
    _namaPenghuni = widget.jadwal?.penghuni ?? '';
    _jumlahBayar = widget.jadwal?.jumlahBayar ?? 0.0;
    _pengulanganBulanan = widget.jadwal?.pengulanganBulanan ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jadwal == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _deskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _deskripsi = value!;
                },
              ),
              SizedBox(height: 16.0),
              Text('Tanggal Sewa:'),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _tanggalSewa,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _tanggalSewa = pickedDate;
                    });
                  }
                },
                child: Text('${_tanggalSewa.day}/${_tanggalSewa.month}/${_tanggalSewa.year}'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _namaPenghuni,
                decoration: InputDecoration(labelText: 'Nama Penghuni'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama penghuni tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _namaPenghuni = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _jumlahBayar.toString(),
                decoration: InputDecoration(labelText: 'Jumlah Bayar (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah bayar tidak boleh kosong';
                  }
                  final double? parsedValue = double.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jumlahBayar = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Pengulangan Bulanan'),
                value: _pengulanganBulanan,
                onChanged: (newValue) {
                  setState(() {
                    _pengulanganBulanan = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final jadwal = Jadwal(
                      id: widget.jadwal?.id ?? '',
                      userId: widget.userId,
                      deskripsi: _deskripsi,
                      tanggalMulai: _tanggalSewa,
                      tanggalAkhir: _tanggalSewa, // Tidak dimasukkan ke dalam formulir
                      penghuni: _namaPenghuni,
                      jumlahBayar: _jumlahBayar,
                      sudahBayar: widget.jadwal?.sudahBayar ?? false,
                      pengulanganBulanan: _pengulanganBulanan,
                    );
                    if (widget.jadwal == null) {
                      await JadwalService().tambahJadwal(jadwal);
                    } else {
                      await JadwalService().editJadwal(jadwal);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
