// lib/services/keuangan_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/keuangan_model.dart';

class KeuanganService {
  final String userId;
  final CollectionReference _keuanganCollection = FirebaseFirestore.instance.collection('keuangan');
  final DocumentReference _saldoKasDocument = FirebaseFirestore.instance.collection('saldo').doc('kas');

  KeuanganService({required this.userId});

  Future<void> tambahKeuangan(Keuangan keuangan) async {
    await _keuanganCollection.add({
      ...keuangan.toMap(),
      'userId': userId,
    });
    if (keuangan.tipe == 'Kas') {
      await _updateSaldoKas(keuangan.jumlah);
    } else if (keuangan.tipe == 'Pengeluaran') {
      await _updateSaldoKas(-keuangan.jumlah);
    }
  }

  Future<void> editKeuangan(Keuangan keuangan) async {
    var oldKeuanganSnapshot = await _keuanganCollection.doc(keuangan.id).get();
    var oldKeuanganData = oldKeuanganSnapshot.data() as Map<String, dynamic>;
    var oldJumlah = oldKeuanganData['jumlah'] as double;

    await _keuanganCollection.doc(keuangan.id).update({
      ...keuangan.toMap(),
      'userId': userId,
    });

    if (keuangan.tipe == 'Kas') {
      await _updateSaldoKas(keuangan.jumlah - oldJumlah);
    } else if (keuangan.tipe == 'Pengeluaran') {
      await _updateSaldoKas(oldJumlah - keuangan.jumlah);
    }
  }

  Future<void> hapusKeuangan(String id) async {
    var keuanganSnapshot = await _keuanganCollection.doc(id).get();
    var keuanganData = keuanganSnapshot.data() as Map<String, dynamic>;
    var jumlah = keuanganData['jumlah'] as double;
    var tipe = keuanganData['tipe'] as String;

    await _keuanganCollection.doc(id).delete();

    if (tipe == 'Kas') {
      await _updateSaldoKas(-jumlah);
    } else if (tipe == 'Pengeluaran') {
      await _updateSaldoKas(jumlah);
    }
  }

  Stream<List<Keuangan>> getKeuangan() {
    return _keuanganCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Keuangan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<List<Keuangan>> getKeuanganByTipe(String tipe) {
    return _keuanganCollection
        .where('userId', isEqualTo: userId)
        .where('tipe', isEqualTo: tipe)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Keuangan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<double> getSaldoKas() {
    return _saldoKasDocument.snapshots().map((snapshot) {
      return (snapshot.data() as Map<String, dynamic>?)?['saldo'] ?? 0.0;
    });
  }

  Future<void> _updateSaldoKas(double jumlah) async {
    var saldoKasSnapshot = await _saldoKasDocument.get();
    var saldoKasData = saldoKasSnapshot.data() as Map<String, dynamic>?;
    var saldo = saldoKasData?['saldo'] as double? ?? 0.0;
    saldo += jumlah;
    await _saldoKasDocument.set({'saldo': saldo});
  }
}
