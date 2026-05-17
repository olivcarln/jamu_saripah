import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/order.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/order_card.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();

    /// FETCH ORDER DARI FIRESTORE
    Future.microtask(() {
      Provider.of<OrderProvider>(
        context,
        listen: false,
      ).fetchOrders();
    });
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.orange;

      case 'Menunggu Pengambilan':
        return Colors.deepPurple;

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
    final orderProvider =
        Provider.of<OrderProvider>(context);
    
    // Ambil user yang login aktif untuk filter data background
    final user = FirebaseAuth.instance.currentUser;

    // UI TETAP SAKLEK, Cuma bagian list data ini kita saring sesuai userId
    final List<OrderModel> myOrders = orderProvider.orders
        .where((order) => order.userId == user?.uid)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        backgroundColor:
            AppColors.primaryOlive,
      ),

      body: myOrders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 90,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Belum ada pesanan",

                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<
                    OrderProvider>(
                  context,
                  listen: false,
                ).fetchOrders();
              },

              child: ListView.builder(
                padding:
                    const EdgeInsets.all(16),

                itemCount: myOrders.length,

                itemBuilder:
                    (context, index) {
                  final order =
                      myOrders[index];

                  debugPrint(
                    "ORDER ID: ${order.id}",
                  );

                  return OrderCard(
                    order: order,

                    /// CANCEL HANYA
                    /// SAAT MASIH DIPROSES
                    onCancel: order.status == 'Diproses'
                        ? () {
                            Provider.of<OrderProvider>(
                              context,
                              listen: false,
                            ).updateStatus(
                              order.id,
                              'Dibatalkan',
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
    );
  }
}