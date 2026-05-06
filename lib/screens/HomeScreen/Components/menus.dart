import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:jamu_saripah/Models/product_cart.dart';
import 'package:jamu_saripah/Screens/DetailScreen/detail_screen.dart';

class Menus extends StatelessWidget {
  const Menus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sedia Jamu sebelum hujan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.70, // Sedikit disesuaikan agar teks harga tidak terpotong ke bawah
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

  Widget _buildProductCard(BuildContext context, Product product) {
    // --- LOGIC DISCOUNT UNTUK ADMIN ---
    // Di sini kita cek apakah admin memberikan harga diskon. 
    // Kita asumsikan admin menyimpan 'originalPrice' di Firestore.
    // Jika tidak ada data dari admin, kita gunakan simulasi harga coret.
    final bool hasDiscount = true; // Nantinya ini bisa diganti (product.originalPrice != null)
    final double strikethroughPrice = product.price + 5000; 

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: _buildProductImage(product.image),
              ),
            ),
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
                    product.size,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 8),

                  // LOGIC UI DISCOUNT
                  if (hasDiscount)
                    Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                          .format(strikethroughPrice),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough, // Efek coret harga lama
                      ),
                    ),

                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(product.price),
                    style: const TextStyle(
                      color: Color(0xFF7B8D5E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageSource) {
    if (imageSource.length > 100) {
      try {
        return Image.memory(
          base64Decode(imageSource),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
        );
      } catch (e) {
        return const Center(child: Icon(Icons.broken_image));
      }
    } else {
      return Image.asset(
        imageSource,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}