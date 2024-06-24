import 'package:flutter/material.dart';
import '../models/keuangan_model.dart';
import '../services/keuangan_service.dart';
import '../widgets/keuangan_form.dart';

class KeuanganScreen extends StatelessWidget {
  final String userId;

  const KeuanganScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengelolaan Keuangan Bersama'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kas'),
              Tab(text: 'Pengeluaran'),
            ],
          ),
        ),
        body: Column(
          children: [
            StreamBuilder<double>(
              stream: KeuanganService(userId: userId).getSaldoKas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Saldo Kas: Rp ${snapshot.data!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                );
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  KeuanganList(tipe: 'Kas', userId: userId), // Pastikan userId diteruskan ke KeuanganList
                  KeuanganList(tipe: 'Pengeluaran', userId: userId), // Pastikan userId diteruskan ke KeuanganList
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KeuanganForm(userId: userId)),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class KeuanganList extends StatelessWidget {
  final String tipe;
  final String userId; // Pastikan userId didefinisikan di sini

  const KeuanganList({super.key, required this.tipe, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Keuangan>>(
      stream: KeuanganService(userId: userId).getKeuanganByTipe(tipe),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return ListView(
          children: snapshot.data!.map((keuangan) {
            return ListTile(
              title: Text(keuangan.nama),
              subtitle: Text('Rp ${keuangan.jumlah.toString()}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KeuanganForm(keuangan: keuangan, userId: userId)),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
