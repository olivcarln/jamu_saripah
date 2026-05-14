import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/order_model.dart';
import 'package:jamu_saripah/Screens/CheckoutScreen/checkout.screen.dart';

class OrderListStateScreen extends StatelessWidget {
  final List<OrderModel> orders; 
  
  const OrderListStateScreen(this.orders, {super.key, });

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   order.userName, 
                    //   style: const TextStyle(
                    //     fontSize: 18, 
                    //     fontWeight: FontWeight.bold,
                    //     color: Color(0xFF7E8959), // ✅ Pakai kode warna langsung jika AppColors masih merah
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    Text(
                      "Tanggal: ${DateFormat('dd MMM yyyy').format(order.createdAt)}\nTotal Pembayaran: Rp ${formatHarga(order.totalAmount)}", 
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              order.method == 'Delivery' ? Icons.delivery_dining : Icons.shopping_bag,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              order.method, 
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7E8959),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              order.status == 'Selesai' ? "Beli Lagi" : "Lihat Pesanan",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Opacity(
                  opacity: 0.2,
                  child: Text(
                    "-------------------------------------------------------------------------",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: Colors.grey, letterSpacing: 2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status: ${order.status}", 
                      style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
              Container(height: 8, color: const Color(0xFFEEEEEE)), 
            ],
          ),
        );
      },
    );
  }
}