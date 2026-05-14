import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:jamu_saripah/Models/product_cart.dart';
import 'package:jamu_saripah/Screens/DetailScreen/detail_screen.dart';

class Menus extends StatelessWidget {
  final Map<String, String> filters;

  const Menus({super.key, this.filters = const {}});

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

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan data"));
              }

              List<QueryDocumentSnapshot> filteredDocs = snapshot.data?.docs ?? [];
              for (var doc in filteredDocs) {
                final data = doc.data() as Map<String, dynamic>;
                print("name: ${data['name']}, size: ${data['size']}");
              }

              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Belum ada produk"),
                  ),
                );
              }

              // Filter kategori (size)
              if (filters['kategori'] != null && filters['kategori']!.isNotEmpty) {
                filteredDocs = filteredDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['size'] ?? '').toString().contains(filters['kategori']!);
                }).toList();
              }

              // Filter jenis jamu
              if (filters['jenis'] != null && filters['jenis']!.isNotEmpty) {
                filteredDocs = filteredDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['name'] ?? '').toString().toLowerCase().contains(filters['jenis']!.toLowerCase());
                }).toList();
              }

              // Sort harga
              if (filters['harga'] == 'Harga Terendah') {
                filteredDocs.sort((a, b) {
                  final aPrice = ((a.data() as Map)['price'] ?? 0) as num;
                  final bPrice = ((b.data() as Map)['price'] ?? 0) as num;
                  return aPrice.compareTo(bPrice);
                });
              } else if (filters['harga'] == 'Harga Tertinggi') {
                filteredDocs.sort((a, b) {
                  final aPrice = ((a.data() as Map)['price'] ?? 0) as num;
                  final bPrice = ((b.data() as Map)['price'] ?? 0) as num;
                  return bPrice.compareTo(aPrice);
                });
              }

              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Produk tidak ditemukan"),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDocs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  final data = filteredDocs[index].data() as Map<String, dynamic>;
                  final product = Product(
                    name: data['name'] ?? '',
                    image: data['imageUrl'] ?? '',
                    price: (data['price'] as num?)?.toDouble() ?? 0,
                    size: data['size'] ?? '',
                    description: data['description'] ?? '',
                    stock: (data['stock'] as num?)?.toInt() ?? 0,
                  );
                  return _buildProductCard(context, product);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final double originalPrice = product.price + 5000;

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
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(originalPrice),
                    style: const TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(product.price),
                    style: const TextStyle(color: Color(0xFF7B8D5E), fontWeight: FontWeight.bold, fontSize: 14),
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
    if (imageSource.length > 100 && !imageSource.startsWith('http')) {
      try {
        return Image.memory(
          base64Decode(imageSource),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        );
      } catch (e) {
        return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
      }
    } else if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[100],
          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      );
    } else {
      return Image.asset(
        imageSource,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[100],
          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      );
    }
  }
}