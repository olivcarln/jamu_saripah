import 'package:flutter/material.dart';
import 'package:jamu_saripah/data/order_data.dart';
import 'package:jamu_saripah/screens/orderscreen/order_history_screen.dart';
import 'product_item.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  final List<Map<String, dynamic>> products = [
    {"name": "Beras Kencur", "price": 12000, "qty": 0},
    {"name": "Kunyit Asem", "price": 15000, "qty": 0},
    {"name": "Wedang Jahe", "price": 13000, "qty": 0},
    {"name": "Temulawak", "price": 14000, "qty": 0},
    {"name": "Jahe Merah", "price": 16000, "qty": 0},
  ];

  // 🔥 TOTAL PRICE (lebih aman)
  int get totalPrice {
    return products.fold<int>(
      0,
      (sum, item) => sum + ((item["price"] as int) * (item["qty"] as int)),
    );
  }

  // 🔥 FORMAT RUPIAH (biar lebih cantik)
  String formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ".",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // 🔥 LIST PRODUK
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductItem(
                name: product["name"],
                price: product["price"],
                qty: product["qty"],

                onAdd: () {
                  setState(() {
                    product["qty"] = (product["qty"] as int) + 1;
                  });
                },

                onRemove: () {
                  if ((product["qty"] as int) > 0) {
                    setState(() {
                      product["qty"] = (product["qty"] as int) - 1;
                    });
                  }
                },
              );
            },
          ),
        ),

        // 🔥 TOTAL + CHECKOUT
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatRupiah(totalPrice),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF7E8959),
                ),
              ),

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF7E8959),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  // 🔥 BUTTON TOTAL
  onPressed: totalPrice == 0
      ? null
      : () {

          // 🔥 AMBIL PRODUK YANG DIPILIH
          final selectedItems = products
              .where((item) => item["qty"] > 0)
              .toList();

          // 🔥 MASUKKAN KE ORDER HISTORY
          for (var item in selectedItems) {

            OrderData.orders.add({
              "title": item["name"],
              "date": "6 Mei 2026",
              "price": item["price"] * item["qty"],
              "status": "Diproses",
            });
          }

          // 🔥 DEBUG
          print(OrderData.orders);

          // 🔥 PINDAH KE ORDER HISTORY
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const OrderHistoryScreen(),
            ),
          );
        },

  child: const Text(
    "Checkout",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
)
            ],
          ),
        )
      ],
    );
  }
}