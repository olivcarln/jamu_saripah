import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/Models/product_cart.dart'; 
import 'package:provider/provider.dart'; 
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'components/product_options_section.dart';
import 'components/add_to_cart_bottom_sheet.dart';

class DetailScreen extends StatefulWidget {
  final Product product; 

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  String selectedSize = "250 ml"; 
  
  // Tetap gue biarin sesuai kodingan lu
  final int pricePerItem = 19500; 

  String formatIDR(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      widget.product.image,
                      width: double.infinity,
                      height: 450,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        formatIDR(widget.product.price),
                        style: const TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF7E8959)
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(thickness: 10, color: Color(0xFFF5F5F5)),
                // ✅ Ini yang benerin error onSizeChanged di Screenshot lu
                ProductOptionsSection(
                  onSizeChanged: (size) => setState(() => selectedSize = size),
                ),
                const SizedBox(height: 120), 
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    }, 
                    icon: const Icon(Icons.remove)
                  ),
                  Text("$quantity", style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => quantity++), 
                    icon: const Icon(Icons.add, color: Color(0xFF7E8959))
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E8959),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  context.read<CartProvider>().addToCart(
                    CartItem(
                      name: widget.product.name,
                      price: widget.product.price,
                      quantity: quantity,
                      image: widget.product.image, 
                      size: selectedSize, 
                    ),
                  );

                  // ✅ Ini yang benerin error named parameter di Screenshot lu
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent, 
                    builder: (context) => AddToCartBottomSheet(
                      product: widget.product,
                      quantity: quantity,
                      size: selectedSize,
                    ),
                  );
                },
                child: Text(
                  "Tambah - ${formatIDR(widget.product.price * quantity)}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}