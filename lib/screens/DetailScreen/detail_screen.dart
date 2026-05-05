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
  String selectedOption = "Beras Kencur Saja"; 
  int currentPrice = 0; 

  @override
  void initState() {
    super.initState();
    // ✅ Inisialisasi awal
    currentPrice = widget.product.price;
    print("DEBUG: Harga awal dari product: ${widget.product.price}");
  }

  void updatePrice(String size, String option) {
    setState(() {
      selectedSize = size;
      selectedOption = option;

      if (option.contains("Paket 3")) {
        currentPrice = 70000; 
      } else {
        int basePrice = widget.product.price; 
        if (size == "350 ml") {
          currentPrice = basePrice + 5000;
        } else if (size == "1 Liter") {
          currentPrice = basePrice + 10000;
        } else {
          currentPrice = basePrice;
        }
      }
      print("DEBUG: Harga update jadi: $currentPrice");
    });
  }

  String formatIDR(int amount) {
    // ✅ Jika currentPrice masih 0, gunakan harga produk sebagai cadangan
    int priceToFormat = (amount == 0) ? widget.product.price : amount;
    
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(priceToFormat);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FORCE UPDATE: Jika currentPrice masih 0 saat build, paksa ambil dari widget
    if (currentPrice == 0 && widget.product.price != 0) {
      currentPrice = widget.product.price;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Gambar
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      // ✅ Harga utama
                      Text(
                        formatIDR(currentPrice),
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
                
                // Pastiin komponen ini manggil callback onSizeChanged
                ProductOptionsSection(
                  onSizeChanged: (size) => updatePrice(size, selectedOption),
                ),
                const SizedBox(height: 120), 
              ],
            ),
          ),

          // Bar bawah untuk tambah ke keranjang
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
    // ✅ Hitung total untuk tombol
    int totalPrice = (currentPrice == 0 ? widget.product.price : currentPrice) * quantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Kontrol Quantity
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
            
            // Tombol Tambah
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
                      price: currentPrice,
                      quantity: quantity,
                      image: widget.product.image, 
                      size: selectedSize, 
                    ),
                  );

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent, 
                    builder: (context) => AddToCartBottomSheet(
                      product: Product(
                        name: widget.product.name,
                        price: currentPrice, 
                        image: widget.product.image,
                        description: widget.product.description,
                        size: selectedSize,
                      ),
                      quantity: quantity,
                      size: selectedSize,
                    ),
                  );
                },
                child: Text(
                  "Tambah - ${formatIDR(totalPrice)}",
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