import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/admin_screen/screens/components/add_product_screen.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  void _deleteProduct(String docId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Hapus Produk"),
        content: Text(
          "Apakah kamu yakin ingin menghapus $name?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(docId)
                    .delete();

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Produk berhasil dihapus"),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal menghapus: $e"),
                  ),
                );
              }
            },
            child: const Text(
              "Hapus",
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
      backgroundColor: const Color(0xFFF9FAF7),

      /// FLOATING BUTTON
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF7E8959),
          elevation: 8,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      /// BODY
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7E8959),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Terjadi kesalahan data."),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("Belum ada produk"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              120,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              final docId = docs[index].id;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                /// CARD CONTENT
                child: Row(
                  children: [
                    /// IMAGE
               ClipRRect(
  borderRadius: BorderRadius.circular(18),

  child: data['imageBase64'] != null &&
          data['imageBase64'].toString().isNotEmpty
      ? Image.memory(
          base64Decode(
            data['imageBase64'],
          ),

          width: 90,
          height: 90,

          fit: BoxFit.cover,
        )
      : Container(
          width: 90,
          height: 90,

          decoration: BoxDecoration(
            color: Colors.grey.shade200,

            borderRadius:
                BorderRadius.circular(18),
          ),

          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        ),
),

                    const SizedBox(width: 16),

                    /// PRODUCT INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'] ?? 'Tanpa Nama',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                   Text(
  NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(data['price']),
),

                          const SizedBox(height: 10),

                             Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _badge(
                                "Diskon ${data['discount']}%",
                                Colors.green,
                              ),

                              _badge(
                                "Stok ${data['stock']}",
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// ACTION BUTTONS
                    Column(
                      children: [
                        /// EDIT BOX
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF7E8959,
                            ).withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: Color(0xFF7E8959),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddProductScreen(
                                    id: docId,
                                    data: data,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// DELETE BOX
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.red.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteProduct(
                              docId,
                              data['name'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// BADGE
  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}