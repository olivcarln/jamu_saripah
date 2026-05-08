import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_dashboard_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_order_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_product_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_voucher_screen.dart';
import 'package:jamu_saripah/screens/hooks/onBoarding/onboarding_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const AdminDashboardScreen(),
    const AdminProductScreen(),
    const AdminVoucherScreen(),
    const AdminOrderScreen(),
  ];

  /// LOGOUT
  void _logout() {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text("Logout"),

        content: const Text(
          "Apakah kamu yakin ingin keluar?",
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text("Batal"),
          ),

          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OnboardingScreen(),
                ),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Berhasil logout"),
                ),
              );
            },

            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      /// FLOATING LOGOUT BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,

        onPressed: _logout,

        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),

        notchMargin: 8,

        child: SizedBox(
          height: 65,

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,

            children: [
              /// DASHBOARD
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },

                icon: Icon(
                  Icons.dashboard,

                  color: currentIndex == 0
                      ? const Color(0xFF7E8959)
                      : Colors.grey,
                ),
              ),

              /// PRODUCT
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },

                icon: Icon(
                  Icons.inventory_2,

                  color: currentIndex == 1
                      ? const Color(0xFF7E8959)
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 30),

              /// VOUCHER
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },

                icon: Icon(
                  Icons.discount,

                  color: currentIndex == 2
                      ? const Color(0xFF7E8959)
                      : Colors.grey,
                ),
              ),

              /// ORDER
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },

                icon: Icon(
                  Icons.receipt_long,

                  color: currentIndex == 3
                      ? const Color(0xFF7E8959)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


