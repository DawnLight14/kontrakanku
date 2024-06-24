// lib/models/jadwal_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Jadwal {
  String id;
  String userId;
  String deskripsi;
  DateTime tanggalMulai;
  DateTime tanggalAkhir;
  String penghuni;
  double jumlahBayar;
  bool sudahBayar;
  bool pengulanganBulanan;

  Jadwal({
    required this.id,
    required this.userId,
    required this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.penghuni,
    required this.jumlahBayar,
    required this.sudahBayar,
    required this.pengulanganBulanan,
  });

  factory Jadwal.fromMap(Map<String, dynamic> data, String documentId) {
    return Jadwal(
      id: documentId,
      userId: data['userId'],
      deskripsi: data['deskripsi'],
      tanggalMulai: (data['tanggalMulai'] as Timestamp).toDate(),
      tanggalAkhir: (data['tanggalAkhir'] as Timestamp).toDate(),
      penghuni: data['penghuni'],
      jumlahBayar: data['jumlahBayar'],
      sudahBayar: data['sudahBayar'],
      pengulanganBulanan: data['pengulanganBulanan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deskripsi': deskripsi,
      'tanggalMulai': Timestamp.fromDate(tanggalMulai),
      'tanggalAkhir': Timestamp.fromDate(tanggalAkhir),
      'penghuni': penghuni,
      'jumlahBayar': jumlahBayar,
      'sudahBayar': sudahBayar,
      'pengulanganBulanan': pengulanganBulanan,
    };
  }
}
