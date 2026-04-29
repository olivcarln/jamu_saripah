import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/AccountScreen/account_screen.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/detail_profile_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/order_history_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'HomeScreen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    VoucherScreen(),
    OrderHistoryScreen(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}