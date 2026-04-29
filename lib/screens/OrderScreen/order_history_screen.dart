import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/detail_profile_screen.dart';
import 'package:jamu_saripah/screens/HomeScreen/home_screen.dart'; 
import 'package:jamu_saripah/screens/OrderScreen/component/empty_order_state_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/component/order_list_item_screen.dart';

import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/account_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Index 2 sesuai urutan "Your order" di widget BottomNav
  int _currentIndex = 2; 

  // Simulasi data order
  final List _myOrders = ["Order 1", "Order 2"]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order History", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6B8E4E),
        elevation: 0,
      ),
      body: _myOrders.isEmpty 
          ? const EmptyOrderStateScreen() 
          : OrderListStateScreen(orders: _myOrders),
          
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Jika klik ikon yang sama, tidak perlu pindah
          if (index == _currentIndex) return;

          // LOGIKA NAVIGASI PINDAH HALAMAN
          if (index == 0) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          } 
          else if (index == 1) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VoucherScreen()));
          } 
          else if (index == 3) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}