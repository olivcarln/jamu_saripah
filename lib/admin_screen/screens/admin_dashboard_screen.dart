import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  /// Fungsi untuk mengambil data dinamis dari Firestore
  Future<Map<String, dynamic>> _getDashboardData() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    try {
      // 1. Fetch Produk
      final productSnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // 2. Fetch Voucher Aktif
      final voucherSnapshot = await FirebaseFirestore.instance
          .collection('global_vouchers')
          .where('expiredAt', isGreaterThan: Timestamp.now())
          .get();

      // 3. Fetch Total Pesanan Bulan Ini (Semua Status)
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('created_at',
              isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
          .get();

      // 4. Fetch Pemasukan (Hanya yang Selesai)
      final revenueSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'Selesai')
          .where('created_at',
              isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
          .get();

      double monthlyRevenue = 0;
      for (var doc in revenueSnapshot.docs) {
        final data = doc.data();
        monthlyRevenue += (data['totalAmount'] ?? 0).toDouble();
      }

      return {
        'totalProducts': productSnapshot.docs.length,
        'totalVouchers': voucherSnapshot.docs.length,
        'totalOrders': orderSnapshot.docs.length,
        'revenue': monthlyRevenue,
      };
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
      rethrow;
    }
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Terjadi kesalahan: ${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
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
                  padding: const EdgeInsets.all(24),
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
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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

                /// GRID STATISTIK
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                  children: [
                    _buildStaticCard(
                      title: "Produk",
                      value: "${data['totalProducts']}",
                      icon: Icons.inventory_2_rounded,
                      color: Colors.blue,
                    ),
                    _buildStaticCard(
                      title: "Voucher",
                      value: "${data['totalVouchers']}",
                      icon: Icons.discount_rounded,
                      color: Colors.green,
                    ),
                    _buildStaticCard(
                      title: "Pesanan",
                      value: "${data['totalOrders']}",
                      icon: Icons.receipt_long_rounded,
                      color: Colors.orange,
                    ),
                    _buildStaticCard(
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

                const SizedBox(height: 30),
                const Text(
                  "Insight Bisnis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// BOX INSIGHT (STATIS)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                      _buildStaticInsightTile(
                        icon: Icons.trending_up,
                        title: "Revenue Meningkat",
                        subtitle: "Pantau performa penjualan harian kamu",
                      ),
                      const Divider(indent: 70, endIndent: 20, height: 1),
                      _buildStaticInsightTile(
                        icon: Icons.local_offer,
                        title: "Voucher Aktif",
                        subtitle: "Terdapat ${data['totalVouchers']} promo yang bisa digunakan",
                      ),
                      const Divider(indent: 70, endIndent: 20, height: 1),
                      _buildStaticInsightTile(
                        icon: Icons.shopping_bag,
                        title: "Pesanan Terbaru",
                        subtitle: "Kelola status orderan user yang masuk",
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

  /// Widget Card Statistik Statis
  Widget _buildStaticCard({
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

  /// Widget Insight List Statis
  Widget _buildStaticInsightTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7E8959).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF7E8959), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF2D3128),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}