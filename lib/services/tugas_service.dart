import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tugas_model.dart';

class TugasService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _tugasCollection(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('tugas');
  }

  Future<void> tambahTugas(Tugas tugas) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _tugasCollection(user.uid).add(tugas.toMap());
    }
  }

  Future<void> editTugas(Tugas tugas) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _tugasCollection(user.uid).doc(tugas.id).update(tugas.toMap());
    }
  }

  Future<void> hapusTugas(String id) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _tugasCollection(user.uid).doc(id).delete();
    }
  }

  Future<void> tandaiSelesai(String id, bool selesai) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _tugasCollection(user.uid).doc(id).update({'completed': selesai});
    }
  }

  Stream<List<Tugas>> getTugas(bool sudahSelesai) {
    final user = _auth.currentUser;
    if (user != null) {
      return _tugasCollection(user.uid)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return Tugas.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList();
          });
    } else {
      return Stream.value([]);
    }
  }
}
