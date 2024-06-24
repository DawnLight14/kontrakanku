import 'package:cloud_firestore/cloud_firestore.dart';

class Keuangan {
  String id;
  String userId;
  String nama;
  double jumlah;
  DateTime tanggal;
  String tipe; // Tambahkan properti tipe
  String deskripsi; // Tambahkan properti deskripsi

  Keuangan({
    required this.id,
    required this.userId,
    required this.nama,
    required this.jumlah,
    required this.tanggal,
    required this.tipe, // Tambahkan ke konstruktor
    required this.deskripsi, // Tambahkan ke konstruktor
  });

  factory Keuangan.fromMap(Map<String, dynamic> data, String documentId) {
    return Keuangan(
      id: documentId,
      userId: data['userId'],
      nama: data['nama'],
      jumlah: data['jumlah'],
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      tipe: data['tipe'], // Ambil dari data
      deskripsi: data['deskripsi'], // Ambil dari data
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nama': nama,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'tipe': tipe, // Tambahkan ke peta
      'deskripsi': deskripsi, // Tambahkan ke peta
    };
  }
}
