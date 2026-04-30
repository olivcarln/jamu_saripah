import 'package:flutter/material.dart';
// Sesuaikan import di bawah ini dengan nama project kamu
import 'package:jamu_saripah/screens/CheckoutSreen/checkout.screen.dart';

class OrderListStateScreen extends StatelessWidget {
  final List orders;
  const OrderListStateScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        // Logika selang-seling: Lihat Pesanan vs Beli Lagi
        bool isReorderMode = index % 2 != 0;

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
                    const Text(
                      "Jatiasih",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B8E4E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Jamu Saripah - Jl. Raya Jatiasih NO.54 RT 003 RW 005\n0.6 km your location",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isReorderMode ? Icons.shopping_bag : Icons.delivery_dining,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isReorderMode ? "Pickup" : "Delivery",
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
                                  builder: (context) => CheckoutScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B8E4E),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              isReorderMode ? "Beli Lagi" : "Lihat Pesanan",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                child: Text(
                  "-------------------------------------------------------------------------",
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Close 07 - 22.00", style: TextStyle(fontSize: 13, color: Colors.black54)),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
              Container(height: 8, color: const Color(0xFFEEEEEE)), // Pembatas antar item
            ],
          ),
        );
      },
    );
  }
}