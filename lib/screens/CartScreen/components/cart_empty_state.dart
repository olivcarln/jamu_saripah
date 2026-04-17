import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Ilustrasi SVG
          SvgPicture.asset(
            'assets/cartShopping.svg', // Pastiin nama filenya bener ya Ip
            width: 200,
            // Kalau mau warnanya senada sama tema hijau lu:
            colorFilter: const ColorFilter.mode(
              Color(0xFF7A875A), 
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 24),
          
          // 2. Teks Pesan
          const Text(
            "Keranjang Masih Kosong",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A875A), // Hijau zaitun tema lu
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}