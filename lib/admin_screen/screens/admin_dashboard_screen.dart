import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<Map<String, dynamic>> _getDashboardData() async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    final voucherSnapshot = await FirebaseFirestore.instance
        .collection('global_vouchers')
        .where('expiredAt', isGreaterThan: Timestamp.now())
        .where('isUsed', isEqualTo: false)
        .get();

    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .get();

    double revenue = 0;
    for (var doc in orderSnapshot.docs) {
      final data = doc.data();
      revenue += (data['totalPrice'] ?? 0).toDouble();
    }

    return {
      'products': productSnapshot.docs.length,
      'vouchers': voucherSnapshot.docs.length,
      'orders': orderSnapshot.docs.length,
      'revenue': revenue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7E8959)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data dashboard kosong"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E8959),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Pantau statistik bisnis Jamu Saripah",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Ringkasan Bisnis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero, 
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCard(
                      title: "Produk",
                      value: "${data['products']}",
                      icon: Icons.inventory_2_rounded,
                      color: Colors.blue,
                    ),
                    _buildCard(
                      title: "Voucher",
                      value: "${data['vouchers']}",
                      icon: Icons.discount_rounded,
                      color: Colors.green,
                    ),
                    _buildCard(
                      title: "Pesanan",
                      value: "${data['orders']}",
                      icon: Icons.receipt_long_rounded,
                      color: Colors.orange,
                    ),
                    _buildCard(
                      title: "Pemasukan",
                      value: NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(data['revenue']),
                      icon: Icons.attach_money_rounded,
                      color: Colors.purple,
                    ),
                  ],
                ),

                // GAP YANG SUDAH DIPERBAIKI
                const SizedBox(height: 30),

                /// TITLE 2
                const Text(
                  "Insight Hari Ini",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// BOX INSIGHT
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.03),
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInsightTile(
                        icon: Icons.trending_up,
                        title: "Revenue meningkat",
                        subtitle: "Pantau penjualan harian produk",
                      ),
                      const Divider(indent: 50, endIndent: 10, height: 1),
                      _buildInsightTile(
                        icon: Icons.local_offer,
                        title: "Voucher aktif",
                        subtitle: "Cek voucher user yang masih berlaku",
                      ),
                      const Divider(indent: 50, endIndent: 10, height: 1),
                      _buildInsightTile(
                        icon: Icons.shopping_bag,
                        title: "Pesanan terbaru",
                        subtitle: "Kelola status order user",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF7E8959).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF7E8959), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }
}
