import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/AccountScreen/account_screen.dart';
import 'package:jamu_saripah/screens/HomeScreen/home_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/order_history_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // URUTANNYA HARUS PERSIS SAMA KAYAK DI BottomNav TADI
  final List<Widget> _children = [
    const HomeScreen(),         // Index 0: Home
    const VoucherScreen(),     // Index 1: Vouchers (Biar gak nyasar lagi!)
    const OrderHistoryScreen(), 
    AccountPage() // Index 2: Your order
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}