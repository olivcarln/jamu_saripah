import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ✅ IMPORT MODEL DAN PROVIDER DENGAN BENAR
import 'package:jamu_saripah/Models/order.dart'; 
import 'package:jamu_saripah/provider/auth_user_provider.dart';
import 'package:jamu_saripah/provider/order_provider.dart' hide OrderModel; // Sembunyikan hantu OrderModel

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  String selectedFilter = "Semua";

  // Sesuaikan status dengan logic bisnis kamu
  final List<String> orderStatuses = [
    "Menunggu",
    "Diproses",
    "Menunggu Pengambilan",
    "Selesai",
    "Dibatalkan",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  // ... (Method _updateStatus dan _confirmPayment tetap sama)

  String formatRupiah(dynamic value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value ?? 0);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses': return Colors.blue;
      case 'Menunggu Pengambilan': return Colors.purple;
      case 'Selesai': return Colors.green;
      case 'Dibatalkan': return Colors.red;
      default: return Colors.orange; // Untuk status 'Menunggu'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text("Admin - Kelola Pesanan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          // ✅ Sekarang allOrders tipenya adalah OrderModel dari Models/order.dart
          final List<OrderModel> allOrders = orderProvider.orders;

          final filteredOrders = selectedFilter == "Semua"
              ? allOrders
              : allOrders.where((order) {
                  if (selectedFilter == "Sukses") return order.status == "Selesai";
                  return order.status == selectedFilter;
                }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text("Tidak ada pesanan"));
          }

          return Column(
            children: [
              // ... (Dropdown Filter tetap sama)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    
                    // Pastikan status dropdown sinkron
                    String currentStatus = orderStatuses.contains(order.status) 
                        ? order.status 
                        : "Menunggu";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _statusBadge(order.status),
                              const Spacer(),
                              Text(
                                DateFormat('dd MMM yyyy').format(order.createdAt),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(order.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(order.address, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const Divider(height: 30),
                          
                          // Menampilkan Items
                          ...order.items.map((item) {
                            final data = item as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text("• ${data['name']} (x${data['qty']})"),
                            );
                          }).toList(),

                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(formatRupiah(order.totalAmount), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          
                          // Dropdown Update Status
                          DropdownButtonFormField<String>(
                            value: currentStatus,
                            decoration: const InputDecoration(labelText: "Update Status"),
                            items: orderStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) {
                              if (val != null) _updateStatus(context, order.id, val);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.bold)),
    );
  }
}