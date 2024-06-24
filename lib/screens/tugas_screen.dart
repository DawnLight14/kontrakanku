import 'package:flutter/material.dart';
import '../models/tugas_model.dart';
import '../services/tugas_service.dart';
import '../widgets/tugas_form.dart';

class TugasScreen extends StatelessWidget {
  final String userId;

  TugasScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembagian Tugas Rumah'),
      ),
      body: StreamBuilder<List<Tugas>>(
        stream: TugasService().getTugas(false),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          
          final List<Tugas> tugasList = snapshot.data ?? [];
          print('Tugas diterima: $tugasList'); // Logging

          if (tugasList.isEmpty) {
            return const Center(child: Text('Tidak ada tugas'));
          }

          return ListView.builder(
            itemCount: tugasList.length,
            itemBuilder: (context, index) {
              final Tugas tugas = tugasList[index];
              return ListTile(
                title: Text(tugas.nama),
                subtitle: Text(tugas.deskripsi),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TugasForm(userId: userId, tugas: tugas)),
                    ).then((value) {
                      if (value != null && value) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas berhasil diupdate')));
                      }
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TugasForm(userId: userId, tugas: tugas)),
                  ).then((value) {
                    if (value != null && value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas berhasil diupdate')));
                    }
                  });
                },
                // Tampilkan ikon checkmark jika sudah selesai
          leading: tugas.completed ? const Icon(Icons.check) : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TugasForm(userId: userId)),
          ).then((value) {
            if (value != null && value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas berhasil ditambahkan')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
