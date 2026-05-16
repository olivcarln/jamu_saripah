import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_dashboard_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_order_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_product_screen.dart';
import 'package:jamu_saripah/admin_screen/screens/admin_voucher_screen.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/hooks/onBoarding/onboarding_screen.dart'; 

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

  final List<String> titles = [
    "Dashboard Admin",
    "Manajemen Produk",
    "Manajemen Voucher",
    "Daftar Pesanan",
  ];

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Logout"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            titles[currentIndex],
            key: ValueKey<int>(currentIndex),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.primaryOlive,
        centerTitle: true,
        elevation: 0,
        actions: [
          if (currentIndex == 0)
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
            body: pages[currentIndex],
      
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.primaryOlive,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOlive.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, "Ringkasan"),
                _buildNavItem(1, Icons.inventory_2_rounded, "Produk"),
                _buildNavItem(2, Icons.discount_rounded, "Promo"),
                _buildNavItem(3, Icons.receipt_long_rounded, "Order"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: isSelected
                  ? Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}