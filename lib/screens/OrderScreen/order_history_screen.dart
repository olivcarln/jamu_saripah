import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:jamu_saripah/Provider/order_provider.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/empty_order_state_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/order_list_item_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
        title: const Text("Order History", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF6B8E4E),
      ),
      // Menggunakan Consumer untuk mendengarkan perubahan di OrderProvider
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final myOrders = orderProvider.orders;

          if (myOrders.isEmpty) {
            return const EmptyOrderStateScreen();
          }

          // Pastikan widget ini menerima List<OrderModel>
          return OrderListStateScreen(orders: myOrders);
        },
      ),
    );
  }
}