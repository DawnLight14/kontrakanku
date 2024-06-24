import 'package:cloud_firestore/cloud_firestore.dart';

class Tugas {
  String id;
  String userId;
  String nama;
  String deskripsi;
  DateTime jadwal;
  bool completed; // Menandai apakah tugas sudah selesai
  String bukti; // Menyimpan bukti penyelesaian tugas

  Tugas({
    required this.id,
    required this.userId,
    required this.nama,
    required this.deskripsi,
    required this.jadwal,
    this.completed = false, // Default value untuk completed
    this.bukti = '', // Default value untuk bukti
  });

  factory Tugas.fromMap(Map<String, dynamic> data, String documentId) {
    return Tugas(
      id: documentId,
      userId: data['userId'],
      nama: data['nama'],
      deskripsi: data['deskripsi'],
      jadwal: (data['jadwal'] as Timestamp).toDate(),
      completed: data['completed'] ?? false, // Mengambil nilai dari database jika ada, jika tidak set default ke false
      bukti: data['bukti'] ?? '', // Mengambil nilai dari database jika ada, jika tidak set default ke string kosong
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nama': nama,
      'deskripsi': deskripsi,
      'jadwal': jadwal,
      'completed': completed, // Menyimpan nilai completed ke database
      'bukti': bukti, // Menyimpan nilai bukti ke database
    };
  }
}
