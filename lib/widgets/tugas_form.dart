import 'package:flutter/material.dart';
import '../models/tugas_model.dart';
import '../services/tugas_service.dart';

class TugasForm extends StatefulWidget {
  final Tugas? tugas;
  final String userId; // Tambahkan userId sebagai parameter dan final

  TugasForm({required this.userId, this.tugas});

  @override
  _TugasFormState createState() => _TugasFormState();
}

class _TugasFormState extends State<TugasForm> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  String _deskripsi = '';
  DateTime _jadwal = DateTime.now();
  bool _completed = false;
  String _bukti = '';
  String _repeatType = 'None';
  List<String> _repeatTypeList = ['None', 'Daily', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    if (widget.tugas != null) {
      _nama = widget.tugas!.nama;
      _deskripsi = widget.tugas!.deskripsi;
      _jadwal = widget.tugas!.jadwal;
      _completed = widget.tugas!.completed;
      _bukti = widget.tugas!.bukti;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tugas == null ? 'Tambah Tugas' : 'Edit Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _nama,
                decoration: InputDecoration(labelText: 'Nama Tugas'),
                onSaved: (value) => _nama = value!,
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                initialValue: _deskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                onSaved: (value) => _deskripsi = value!,
              ),
              Row(
                children: <Widget>[
                  Text('Tanggal Tugas: '),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _jadwal,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _jadwal) {
                        setState(() {
                          _jadwal = pickedDate;
                        });
                      }
                    },
                    child: Text('${_jadwal.toLocal()}'.split(' ')[0]),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pengulangan'),
                value: _repeatType,
                items: _repeatTypeList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _repeatType = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Tugas Selesai'),
                value: _completed,
                onChanged: (value) {
                  setState(() {
                    _completed = value!;
                  });
                },
              ),
              TextFormField(
                initialValue: _bukti,
                decoration: InputDecoration(labelText: 'Bukti Penyelesaian Tugas'),
                onSaved: (value) => _bukti = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Tugas tugas = Tugas(
                      id: widget.tugas?.id ?? '',
                      userId: widget.userId, // Sertakan userId di sini
                      nama: _nama,
                      deskripsi: _deskripsi,
                      jadwal: _jadwal,
                      completed: _completed,
                      bukti: _bukti,
                    );
                    if (widget.tugas == null) {
                      await TugasService().tambahTugas(tugas);
                    } else {
                      await TugasService().editTugas(tugas);
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
