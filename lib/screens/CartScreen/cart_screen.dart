import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Wajib buat SVG
import 'package:jamu_saripah/Models/cart_item.dart'; // Import model yang kita bikin

class CartScreen extends StatelessWidget {
  // Ini pintu masuk datanya dari Home tadi
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      
      // 1. App Bar Hijau Khas Jamu Saripah
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7E8959),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      // 2. Logic: Kalau List Kosong tampilkan SVG, kalau ada isi tampilkan List
      body: cartItems.isEmpty
          ? _buildEmptyState()
          : _buildCartList(),

      // 3. Bottom Summary (Hanya muncul kalau ada barang)
      bottomNavigationBar: cartItems.isEmpty 
          ? null 
          : _buildBottomSummary(),
    );
  }

  // --- Widget State Keranjang Kosong ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/cartShopping.svg',
            height: 200,
            colorFilter: const ColorFilter.mode(
              Color(0xFF7E8959),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Keranjang Masih kosong",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Widget Daftar Produk ---
  Widget _buildCartList() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.check_box, color: Color(0xFF7E8959)),
              SizedBox(width: 10),
              Text("Pilih semua", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartCard(item);
            },
          ),
        ),
      ],
    );
  }

  // --- Widget Card Per Produk ---
  Widget _buildCartCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            item.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            color: const Color(0xFF7E8959),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  "Rp ${item.price}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Checkout Bar ---
  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total harga", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                "Rp 56.000", // Ini nanti bisa dibikin dinamis 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF7E8959)),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF634E34),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}