import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_order_screen.dart';

class AdminOrderList extends StatelessWidget {
  const AdminOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesanan Masuk")),
      body: StreamBuilder<QuerySnapshot>(
        // 1. DISESUAIKAN: Pakai 'createdAt' sesuai isi database Firestore lu
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              var orderData = order.data() as Map<String, dynamic>;
              
              String? emailField = orderData['userEmail'] ?? orderData['email'];
              String rawName = orderData['userName'] ?? '';

              // 2. LOGIKA FIX: Deteksi nama "User", nama kosong, atau email kosong
              String displayName = "User";
              
              if ((rawName == 'User' || rawName.trim().isEmpty) && 
                  emailField != null && 
                  emailField.trim().isNotEmpty && 
                  emailField.contains('@')) {
                // Kalau namanya cuma "User" tapi emailnya ada, potong emailnya
                displayName = emailField.split('@')[0];
              } else if (rawName.trim().isNotEmpty) {
                // Kalau ada nama aslinya (kayak "Dang" atau "naipusya"), pakai nama itu!
                displayName = rawName;
              }

              // Fungsi lokal untuk formatting harga sederhana
              String formatHarga(int harga) {
                return harga.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.',
                );
              }

              // 3. UI ASLI BAWAAN LU (KOSMETIK SAMA SEKALI TIDAK BERUBAH)
              return ListTile(
                title: Text("Pesanan dari: $displayName"),
                // FIX: Ubah dari totalPrice menjadi totalAmount agar angkanya sinkron dari Firestore
                subtitle: Text("Total: Rp ${formatHarga(orderData['totalAmount'] ?? 0)}"),
                trailing: Text(
                  orderData['status'] ?? 'Pending', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (orderData['status'] == 'Pending' || orderData['status'] == 'Diproses') 
                        ? Colors.red 
                        : Colors.green,
                  ),
                ),
                onTap: () {
                  // FIX: Begitu di-klik, lempar ke halaman AdminOrderScreen (detail pesanan)
                  // Jika AdminOrderScreen milik lu butuh passing data ID/Model, tinggal disesuaikan ya co!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminOrderScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}