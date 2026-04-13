// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/product_cart.dart';


class HomeRecommended extends StatelessWidget {
  const HomeRecommended({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            "Recommended For You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // Grid Produk
          GridView.builder(
            shrinkWrap: true, // WAJIB supaya bisa masuk dalam scroll halaman utama
            physics: const NeverScrollableScrollPhysics(), // Scroll-nya ikut halaman utama saja
            itemCount: allProducts.length, // Sesuai jumlah di products.dart (6 produk)
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75, // Atur angka ini kalau card-nya kepotong
            ),
            itemBuilder: (context, index) {
              final product = allProducts[index];
              return _buildProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  // Widget Kartu Produk Satuan
  Widget _buildProductCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.size, // Menampilkan ukuran (250 ml, dsb)
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  product.price,
                  style: const TextStyle(
                    color: Color(0xFF7B8D5E), // Hijau tema jamu kamu
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}