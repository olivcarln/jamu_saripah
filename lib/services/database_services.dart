import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi untuk User membuat pesanan
  Future<void> buatPesanan({
    required List<Map<String, dynamic>> items,
    required double total,
    required String method,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User tidak login");

    await _db.collection('orders').add({
      'userId': user.uid,
      'userName': user.displayName ?? "Pelanggan",
      'items': items,
      'totalPrice': total,
      'method': method,
      'status': 'Pending',
      'orderDate': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStatusPesanan(String docId, String status) async {
    await _db.collection('orders').doc(docId).update({'status': status});
  }
}