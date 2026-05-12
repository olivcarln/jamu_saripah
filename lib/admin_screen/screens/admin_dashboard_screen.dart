import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<Map<String, dynamic>> _getDashboardData() async {
  // 1. Ambil Produk
  final productSnapshot = await FirebaseFirestore.instance
      .collection('products')
      .get();

  // 2. Ambil Voucher (Hanya yang belum expired, sesuai dengan Voucher Screen)
  final voucherSnapshot = await FirebaseFirestore.instance
      .collection('global_vouchers') // Nama koleksi dari file AdminVoucherScreen
      .where('expiredAt', isGreaterThan: Timestamp.now()) // Filter agar sinkron
      .where('isUsed', isEqualTo: false) // HANYA yang belum dinonaktifkan
      .get();

  // 3. Ambil Pesanan
  final orderSnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .get();

  // 4. Hitung Revenue
  double revenue = 0;
  for (var doc in orderSnapshot.docs) {
    final data = doc.data();
    revenue += (data['totalPrice'] ?? 0).toDouble();
  }

  return {
    'products': productSnapshot.docs.length,
    'vouchers': voucherSnapshot.docs.length, // Menampilkan jumlah yang aktif saja
    'orders': orderSnapshot.docs.length,
    'revenue': revenue,
  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF7E8959),

        title: const Text(
          "Dashboard Admin",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDashboardData(),

        builder: (context, snapshot) {
          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7E8959)),
            );
          }

          /// ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          /// DATA NULL
          if (!snapshot.hasData) {
            return const Center(child: Text("Data dashboard kosong"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// HEADER
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFF7E8959),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Admin Dashboard",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Pantau statistik bisnis Jamu Saripah",

                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// TITLE
                const Text(
                  "Ringkasan Bisnis",

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// GRID
                GridView.count(
                  crossAxisCount: 2,

                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  crossAxisSpacing: 15,

                  mainAxisSpacing: 15,

                  childAspectRatio: 1.1,

                  children: [
                    _buildCard(
                      title: "Produk",

                      value: "${data['products']}",

                      icon: Icons.inventory_2,

                      color: Colors.blue,
                    ),

                    _buildCard(
                      title: "Voucher",

                      value: "${data['vouchers']}",

                      icon: Icons.discount,

                      color: Colors.green,
                    ),

                    _buildCard(
                      title: "Pesanan",

                      value: "${data['orders']}",

                      icon: Icons.receipt_long,

                      color: Colors.orange,
                    ),

                    _buildCard(
                      title: "Pemasukan",

                      value: "Rp ${data['revenue'].toInt()}",

                      icon: Icons.attach_money,

                      color: Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// INSIGHT
                const Text(
                  "Insight Hari Ini",

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,

                        color: Colors.black.withOpacity(0.04),
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

                      const Divider(),

                      _buildInsightTile(
                        icon: Icons.local_offer,

                        title: "Voucher aktif",

                        subtitle: "Cek voucher user yang masih berlaku",
                      ),

                      const Divider(),

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
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(0.1),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                value,

                style: const TextStyle(
                  fontSize: 22,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(title, style: const TextStyle(color: Colors.grey)),
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
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        backgroundColor: const Color(0xFF7E8959).withOpacity(0.1),

        child: Icon(icon, color: const Color(0xFF7E8959)),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

      subtitle: Text(subtitle),
    );
  }
}
