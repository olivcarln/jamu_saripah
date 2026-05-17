import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_finance_screen.dart';

// Import sesuai struktur folder project kamu
import 'package:jamu_saripah/admin_screen/screens/admin_order_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_product_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_voucher_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  /// Fungsi untuk mengambil data dinamis dari Firestore
  /// Fungsi untuk mengambil data dinamis dari Firestore
  Future<Map<String, dynamic>> _getDashboardData() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    // 1. Fetch Produk
    final productSnapshot = await FirebaseFirestore.instance.collection('products').get();

    // 2. Fetch Voucher (Hanya yang AKTIF - belum expired)
    final voucherSnapshot = await FirebaseFirestore.instance
        .collection('global_vouchers')
        .where('expiredAt', isGreaterThan: Timestamp.now()) 
        .get();
   
// Ubah bagian ini agar filter waktunya sama dengan Pemasukan
    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Selesai')
        .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .get();

    // 4. Hitung Pemasukan (Tetap ambil dari semua yang 'Selesai' di bulan ini)
    final revenueSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Selesai')
        .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .get();

    double monthlyRevenue = 0;
    for (var doc in revenueSnapshot.docs) {
      final data = doc.data();
      monthlyRevenue += (data['totalPrice'] ?? 0).toDouble();
    }

    return {
      'totalProducts': productSnapshot.docs.length,
      'totalVouchers': voucherSnapshot.docs.length,
      'totalOrders': orderSnapshot.docs.length, // Jumlah pesanan aktif
      'revenue': monthlyRevenue,
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
            return Center(child: Text("Error: ${snapshot.error}"));
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
                    _buildCard(
                      title: "Produk",
                      value: "${data['totalProducts']}",
                      icon: Icons.inventory_2_rounded,
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminProductScreen())),
                    ),
                    _buildCard(
                      title: "Voucher",
                      value: "${data['totalVouchers']}", // Hanya yang aktif
                      icon: Icons.discount_rounded,
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminVoucherScreen())),
                    ),
                    _buildCard(
                      title: "Pesanan",
                      value: "${data['totalOrders']}",
                      icon: Icons.receipt_long_rounded,
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminOrderScreen())),
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFinanceScreen())),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
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
                        onTap: () {},
                      ),
                      const Divider(indent: 50, endIndent: 10, height: 1),
                      _buildInsightTile(
                        icon: Icons.local_offer,
                        title: "Voucher aktif",
                        subtitle: "Cek voucher user yang masih berlaku",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminVoucherScreen())),
                      ),
                      const Divider(indent: 50, endIndent: 10, height: 1),
                      _buildInsightTile(
                        icon: Icons.shopping_bag,
                        title: "Pesanan terbaru",
                        subtitle: "Kelola status order user",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminOrderScreen())),
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

  /// Widget Card Statistik
  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
      ),
    );
  }

  /// Widget Tile Insight
  Widget _buildInsightTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
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
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}