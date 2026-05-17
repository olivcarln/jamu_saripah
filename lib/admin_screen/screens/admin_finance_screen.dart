import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminFinanceScreen extends StatefulWidget {
  const AdminFinanceScreen({super.key});

  @override
  State<AdminFinanceScreen> createState() => _AdminFinanceScreenState();
}

class _AdminFinanceScreenState extends State<AdminFinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  /// Fungsi untuk fetch data Keuangan & Jumlah Pesanan yang Selesai
  Future<Map<String, dynamic>> _fetchFinanceData(String range) async {
    final now = DateTime.now();
    DateTime startDate;

    if (range == 'Hari') {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (range == 'Minggu') {
      startDate = now.subtract(Duration(days: now.weekday - 1));
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
    } else if (range == 'Bulan') {
      startDate = DateTime(now.year, now.month, 1);
    } else {
      startDate = DateTime(now.year, 1, 1);
    }

    // QUERY: Pastikan menggunakan field 'created_at' sesuai database kamu
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Selesai') // Sinkron: Hanya hitung yang Selesai
        .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .get();

    double totalRevenue = 0;
    int totalOrders = snapshot.docs.length; // Langsung hitung jumlah dokumen

    for (var doc in snapshot.docs) {
      final data = doc.data();
      // Pastikan menggunakan totalPrice atau totalAmount sesuai field di database
      totalRevenue += (data['totalPrice'] ?? data['totalAmount'] ?? 0).toDouble();
    }

    return {
      'revenue': totalRevenue,
      'orders': totalOrders,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text("Laporan Keuangan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E8959),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Hari"),
            Tab(text: "Minggu"),
            Tab(text: "Bulan"),
            Tab(text: "Tahun"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFinanceView('Hari'),
          _buildFinanceView('Minggu'),
          _buildFinanceView('Bulan'),
          _buildFinanceView('Tahun'),
        ],
      ),
    );
  }

  Widget _buildFinanceView(String range) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchFinanceData(range),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF7E8959)));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
        }

        final data = snapshot.data ?? {'revenue': 0.0, 'orders': 0};
        final double revenue = data['revenue'];
        final int orders = data['orders'];

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /// CARD UTAMA (PEMASUKAN)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7E8959), Color(0xFF9BAB70)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7E8959).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pemasukan ($range)",
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(revenue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// CARD KEDUA (TOTAL PESANAN BERHASIL)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_outline, color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pesanan Berhasil",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "$orders Pesanan",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Ringkasan Aktivitas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildSimpleTile(
                icon: Icons.account_balance_wallet,
                title: "Saldo Terverifikasi",
                value: "100%",
                color: Colors.green,
              ),
              _buildSimpleTile(
                icon: Icons.assignment_turned_in,
                title: "Filter Status",
                value: "Selesai",
                color: Colors.blue,
              ),
              
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Laporan ini disinkronkan dengan dashboard. Hanya menghitung pesanan yang sudah berstatus 'Selesai'.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}