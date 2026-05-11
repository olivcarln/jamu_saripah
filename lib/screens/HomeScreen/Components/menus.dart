import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

          /// FIRESTORE DATA
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                .snapshots(),

            builder: (context, snapshot) {
              /// LOADING
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              /// ERROR
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan data"));
              }

              final docs = snapshot.data?.docs ?? [];

              /// EMPTY
              if (docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Belum ada produk"),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: docs.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.70,
                ),

                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  /// CONVERT FIRESTORE DATA TO PRODUCT MODEL
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
            /// IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),

                child: _buildProductImage(product.image),
              ),
            ),

            /// INFO
            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// NAME
                  Text(
                    product.name,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  /// SIZE
                  Text(
                    product.size,

                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),

                  const SizedBox(height: 8),

                  /// ORIGINAL PRICE
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(originalPrice),

                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                  /// FINAL PRICE
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
    /// BASE64
    if (imageSource.length > 100 && !imageSource.startsWith('http')) {
      try {
        return Image.memory(
          base64Decode(imageSource),

          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,

          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        );
      } catch (e) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }
    /// FIREBASE IMAGE URL
    else if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,

        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(child: CircularProgressIndicator());
        },

        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[100],

            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          );
        },
      );
    }
    /// LOCAL ASSET
    else {
      return Image.asset(
        imageSource,

        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }

          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: child,
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[100],

            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          );
        },
      );
    }
  }
}
