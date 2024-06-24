// lib/screens/jadwal_screen.dart
import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';
import '../services/jadwal_service.dart';
import '../widgets/jadwal_form.dart';

class JadwalScreen extends StatelessWidget {
  final String userId; // Tambahkan userId di sini

  JadwalScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Kontrak dan Pembayaran'),
      ),
      body: StreamBuilder<List<Jadwal>>(
        stream: JadwalService().getJadwal(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Jadwal jadwal = snapshot.data![index];
              return ListTile(
                title: Text(jadwal.deskripsi),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal Sewa: ${jadwal.tanggalMulai.toLocal()}'),
                    Text('Nama Penghuni: ${jadwal.penghuni}'),
                    Text('Jumlah Bayar: Rp ${jadwal.jumlahBayar.toStringAsFixed(2)}'),
                    Text('Pengulangan Bulanan: ${jadwal.pengulanganBulanan ? 'Ya' : 'Tidak'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Pembayaran'),
                              content: Text('Apakah sudah melakukan pembayaran?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Belum'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await JadwalService().tandaiSudahBayar(jadwal.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Sudah'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(jadwal.sudahBayar ? 'Sudah Bayar' : 'Belum Bayar'),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Apakah Anda yakin ingin menghapus jadwal pembayaran ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await JadwalService().hapusJadwal(jadwal.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JadwalForm(userId: userId, jadwal: jadwal)),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JadwalForm(userId: userId)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
