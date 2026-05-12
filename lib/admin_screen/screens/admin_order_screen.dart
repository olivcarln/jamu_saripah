import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// TODO: Tambahkan fitur filter berdasarkan status pesanan (Menunggu, Diproses, Dikirim, Selesai, Dibatalkan)
class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  /// UPDATE STATUS PESANAN
  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': status},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status berhasil diubah menjadi $status")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal update status: $e")));
    }
  }

  /// KONFIRMASI PEMBAYARAN
  Future<void> _confirmPayment(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'paymentConfirmed': true, 'status': 'Diproses'},
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pembayaran berhasil dikonfirmasi")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal konfirmasi pembayaran: $e")),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;

      case 'Diproses':
        return Colors.blue;

      case 'Dikirim':
        return Colors.purple;

      case 'Selesai':
        return Colors.green;

      case 'Dibatalkan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7E8959)),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan data pesanan"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada pesanan"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: docs.length,

            itemBuilder: (context, index) {
              final doc = docs[index];

              final data = doc.data() as Map<String, dynamic>;

              final status = data['status'] ?? 'Menunggu';

              final paymentConfirmed = data['paymentConfirmed'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// HEADER
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: _statusColor(status).withOpacity(0.1),

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Icon(
                            Icons.shopping_bag,
                            color: _statusColor(status),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                data['userName'] ?? 'User',

                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(data['userEmail'] ?? '-'),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: _statusColor(status).withOpacity(0.1),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            status,

                            style: TextStyle(
                              color: _statusColor(status),

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// DETAIL ORDER
                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.grey[100],

                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        children: [
                          _buildInfoRow(
                            "Total Harga",
                            "Rp ${data['totalPrice'] ?? 0}",
                          ),

                          const SizedBox(height: 10),

                          _buildInfoRow(
                            "Metode Pembayaran",
                            data['paymentMethod'] ?? '-',
                          ),

                          const SizedBox(height: 10),

                          _buildInfoRow("Alamat", data['address'] ?? '-'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// STATUS PEMBAYARAN
                    Row(
                      children: [
                        Icon(
                          paymentConfirmed ? Icons.check_circle : Icons.pending,

                          color: paymentConfirmed
                              ? Colors.green
                              : Colors.orange,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          paymentConfirmed
                              ? "Pembayaran Terkonfirmasi"
                              : "Menunggu Konfirmasi Pembayaran",

                          style: TextStyle(
                            color: paymentConfirmed
                                ? Colors.green
                                : Colors.orange,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ACTION BUTTON
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        /// KONFIRMASI
                        if (!paymentConfirmed)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),

                            onPressed: () {
                              _confirmPayment(doc.id);
                            },

                            icon: const Icon(Icons.check, color: Colors.white),

                            label: const Text(
                              "Konfirmasi",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                        /// DIPROSES
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),

                          onPressed: () {
                            _updateOrderStatus(doc.id, "Diproses");
                          },

                          child: const Text(
                            "Diproses",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        /// DIKIRIM
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),

                          onPressed: () {
                            _updateOrderStatus(doc.id, "Dikirim");
                          },

                          child: const Text(
                            "Dikirim",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        /// SELESAI
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),

                          onPressed: () {
                            _updateOrderStatus(doc.id, "Selesai");
                          },

                          child: const Text(
                            "Selesai",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 120,

          child: Text(
            title,

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(child: Text(value)),
      ],
    );
  }
}
