import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jamu_saripah/Provider/order_provider.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/empty_order_state_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/order_list_item_screen.dart'; // Pastikan file ini ada

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order History", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7E8959),
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final myOrders = orderProvider.orders;

          if (myOrders.isEmpty) {
            return const EmptyOrderStateScreen();
          }

          // Ini yang nampilin list pesanan lo
          return OrderListStateScreen(orders: myOrders); 
        },
      ),
    );
  }
}