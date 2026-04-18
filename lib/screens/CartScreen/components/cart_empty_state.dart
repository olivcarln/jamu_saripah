import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key}); // Pastikan constructor ini ada

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/cartShopping.svg', 
            height: 180, 
            colorFilter: const ColorFilter.mode(Color(0xFF7E8959), BlendMode.srcIn)
          ),
          const SizedBox(height: 20),
          const Text("Keranjang kosong nih!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}