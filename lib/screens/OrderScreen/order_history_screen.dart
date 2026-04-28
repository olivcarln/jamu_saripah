import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/empty_order_state_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/order_list_item_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Simulasi data. Jika list kosong [], maka tampilan kosong akan muncul.
  final List _myOrders = ["Order 1", "Order 2"]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Order History", 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900
          )),
        centerTitle: true,
        backgroundColor: const Color(0xFF6B8E4E),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      // LOGIKA FLOW:
      body: _myOrders.isEmpty 
          ? EmptyOrderStateScreen() 
          : OrderListStateScreen(orders: _myOrders),
          
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6B8E4E),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // "Your Order" active
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Vouchers"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Your order"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}