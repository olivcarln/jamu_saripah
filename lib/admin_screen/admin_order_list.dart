import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesanan Masuk")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              return ListTile(
                title: Text("Pesanan dari: ${order['userName']}"),
                subtitle: Text("Total: Rp ${order['totalPrice']}"),
                trailing: Text(order['status'], 
                  style: TextStyle(color: order['status'] == 'Pending' ? Colors.red : Colors.green)),
                onTap: () {
                  // Tambahkan logika untuk mengubah status jadi "Selesai" atau "Diproses"
                },
              );
            },
          );
        },
      ),
    );
  }
}