// lib/services/jadwal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/jadwal_model.dart';

class JadwalService {
  final CollectionReference _jadwalCollection = FirebaseFirestore.instance.collection('jadwal');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> tambahJadwal(Jadwal jadwal) async {
    await _jadwalCollection.add({
      ...jadwal.toMap(),
      'userId': _userId,
    });
  }

  Future<void> editJadwal(Jadwal jadwal) async {
    await _jadwalCollection.doc(jadwal.id).update({
      ...jadwal.toMap(),
      'userId': _userId,
    });
  }

  Future<void> hapusJadwal(String id) async {
    await _jadwalCollection.doc(id).delete();
  }

  Future<void> tandaiSudahBayar(String id) async {
    await _jadwalCollection.doc(id).update({'sudahBayar': true});
  }

  Stream<List<Jadwal>> getJadwal() {
    return _jadwalCollection.where('userId', isEqualTo: _userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Jadwal.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
