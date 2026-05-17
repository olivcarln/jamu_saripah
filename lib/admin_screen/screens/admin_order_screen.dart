import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  String selectedFilter = "Semua";

  final List<String> orderStatuses = [
    "Diproses",
    "Menunggu Pengambilan",
    "Selesai",
    "Dibatalkan",
  ];

  String formatRupiah(dynamic value) {
    // Memastikan value dikonversi ke angka (int/double) sebelum diformat
    final num price = (value is num) ? value : (num.tryParse(value.toString()) ?? 0);
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses': return Colors.orange;
      case 'Menunggu Pengambilan': return Colors.deepPurple;
      case 'Selesai': case 'Sudah Diambil': return Colors.green;
      case 'Dibatalkan': return Colors.red;
      default: return Colors.grey;
    }
  }

  /// FIX UTAMA 1: Fungsi render gambar yang kebal error (Bulletproof Image Loader)
  Widget buildOrderImage(String image) {
    try {
      if (image.isEmpty) {
        return Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey));
      }
      if (image.startsWith('http')) {
        return Image.network(image, width: 60, height: 60, fit: BoxFit.cover);
      }
      if (image.startsWith('assets/')) {
        return Image.asset(image, width: 60, height: 60, fit: BoxFit.cover);
      }
      
      // Jika string berupa base64 murni
      String cleanBase64 = image;
      if (image.contains(',')) {
        cleanBase64 = image.split(',').last;
      }
      return Image.memory(
        base64Decode(cleanBase64),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } catch (e) { 
      debugPrint("Admin gagal load gambar: $e");
      return Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.red)); 
    }
  }

  Future<void> updateStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': status});
  }

  Future<void> confirmPayment(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'paymentConfirmed': true,
      'status': 'Selesai'
    });
  }

  String formatDate(dynamic date) {
    if (date == null) return "-";
    DateTime finalDate = (date is Timestamp) ? date.toDate() : date;
    return DateFormat('dd MMM yyyy, HH:mm').format(finalDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: Column(
        children: [
          /// FILTER HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "Semua", child: Text("Semua Pesanan")),
                          DropdownMenuItem(value: "Diproses", child: Text("Sedang Diproses")),
                          DropdownMenuItem(value: "Menunggu Pengambilan", child: Text("Menunggu Pengambilan")),
                          DropdownMenuItem(value: "Selesai", child: Text("Pesanan Selesai")),
                          DropdownMenuItem(value: "Dibatalkan", child: Text("Pesanan Dibatalkan")),
                        ],
                        onChanged: (value) => setState(() => selectedFilter = value!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF7E8959)),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 1, child: Text("Hapus > 1 Hari")),
                    const PopupMenuItem(value: 7, child: Text("Hapus > 1 Minggu")),
                    const PopupMenuItem(value: 30, child: Text("Hapus > 1 Bulan")),
                  ],
                ),
              ],
            ),
          ),

          /// LIST PESANAN
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').orderBy('created_at', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Terjadi error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final docs = snapshot.data!.docs;
                final filteredDocs = selectedFilter == "Semua" 
                    ? docs 
                    : docs.where((d) {
                        final mapData = d.data() as Map<String, dynamic>;
                        return mapData['status'] == selectedFilter;
                      }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("Tidak ada pesanan", style: TextStyle(color: Colors.grey)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    final id = filteredDocs[index].id;
                    
                    // Ambil list items dengan aman
                    final List<dynamic> items = data['items'] is List ? data['items'] : [];
                    bool isConfirmed = data['paymentConfirmed'] ?? false;
                    String status = data['status'] ?? "Diproses";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header Info
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _statusColor(status).withOpacity(0.1), 
                                child: Icon(Icons.person, color: _statusColor(status)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['userName'] ?? "User", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text(formatDate(data['created_at']), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              _statusBadge(status),
                            ],
                          ),
                          const Divider(height: 30),
                          
                          /// Info Ringkas
                          _buildInfoRow("Total", formatRupiah(data['totalAmount']), isBold: true),
                          _buildInfoRow("Metode", data['paymentMethod'] ?? "-"),
                          _buildInfoRow("Outlet", data['address'] ?? "-"),
                          
                          const SizedBox(height: 15),

                          /// DAFTAR MENU PESANAN
                          if (items.isNotEmpty) ...[
                            const Text("Menu Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                final item = items[i] is Map ? items[i] as Map<String, dynamic> : {};
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: buildOrderImage(item['image'] ?? ""),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item['name'] ?? "Menu", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                            Text("${item['size'] ?? '350 ml'} | Qty: ${item['qty'] ?? 1}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Text(formatRupiah(item['price'] ?? 0), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],

                          const SizedBox(height: 15),

                          /// Update Status Dropdown
                          DropdownButtonFormField<String>(
                            value: orderStatuses.contains(status) ? status : "Diproses",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              filled: true, fillColor: Colors.grey[100], 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
                            ),
                            items: orderStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) => updateStatus(id, val!),
                          ),

                          const SizedBox(height: 12),

                          /// Tombol Konfirmasi
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (isConfirmed || status == 'Selesai') ? null : () => confirmPayment(id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7E8959),
                                disabledBackgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                (isConfirmed || status == 'Selesai') ? "Pesanan Selesai & Lunas" : "Konfirmasi Pembayaran",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _statusBadge(String s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: _statusColor(s).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
    child: Text(s, style: TextStyle(color: _statusColor(s), fontSize: 11, fontWeight: FontWeight.bold)),
  );
}