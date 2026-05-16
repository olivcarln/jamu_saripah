import 'package:flutter/material.dart';
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/AccountScreen/account_screen.dart';
import 'package:jamu_saripah/screens/HomeScreen/home_screen.dart';
import 'package:jamu_saripah/screens/OrderScreen/order_history_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final bool clearCart;

  /// TAMBAHAN
  final int initialIndex;

  const MainScreen({
    super.key,
    this.clearCart = false,

    /// DEFAULT HOME
    this.initialIndex = 0,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    /// INDEX AWAL
    _currentIndex = widget.initialIndex;

    /// CLEAR CART
    if (widget.clearCart) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        Provider.of<CartProvider>(
          context,
          listen: false,
        ).clearCart();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const HomeScreen(),

      /// INDEX 1
      const OrderHistoryScreen(),

      AccountPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: children,
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