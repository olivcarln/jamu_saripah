import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Screens/DetailScreen/components/add_to_cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:jamu_saripah/Models/cart_item.dart'; 
import 'package:jamu_saripah/Models/product_cart.dart'; 
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/screens/CartScreen/cart_screen.dart';
import 'components/product_options_section.dart'; // File pilihan lu tadi

class DetailScreen extends StatefulWidget {
  final Product product; 
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentQuantity = 1;
  String selectedSize = "350 ml";
  final Color armyGreen = const Color(0xFF7E8959);

  // LOGIC HARGA: Update harga real-time
  int get currentUnitPrice {
    if (selectedSize == "250 ml") return 15000;
    if (selectedSize == "1 Liter") return 55000;
    return 19500; // Default 350ml
  }

  String _formatIDR(int amount) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [_buildPoinBanner()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(widget.product.image, height: 280, fit: BoxFit.contain)),
            _buildProductInfo(),
            const Divider(thickness: 6, color: Color(0xFFF8F8F8)),
            // ✅ MASUKIN COMPONENT LU DI SINI
            ProductOptionsSection(
              onSizeChanged: (newSize) => setState(() => selectedSize = newSize),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: AddToCartBottomSheet(
        price: currentUnitPrice,
        onAddToCart: (qty) {
          setState(() => currentQuantity = qty);
          // Tambah ke Provider
          context.read<CartProvider>().addToCart(CartItem(
            name: widget.product.name, price: currentUnitPrice, quantity: currentQuantity,
            image: widget.product.image, size: selectedSize, isChecked: true,
          ));
          _showSuccessModal();
        },
      ),
    );
  }

  Widget _buildPoinBanner() {
    return Container(
      margin: const EdgeInsets.only(right: 15, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFFF1F4E8), borderRadius: BorderRadius.circular(15)),
      child: const Row(children: [Icon(Icons.stars, size: 14, color: Colors.green), SizedBox(width: 5), Text("Kamu berpotensi mendapatkan 4 Jamu Poin", style: TextStyle(color: Colors.black, fontSize: 9))]),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Minuman tradisional segar tanpa pengawet.", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 15),
          Text(_formatIDR(currentUnitPrice), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: armyGreen)),
        ],
      ),
    );
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Lengkapi Belanjamu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: armyGreen)),
            const SizedBox(height: 20),
            _buildModalProductCard(),
            const SizedBox(height: 25),
            _buildModalButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalProductCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        Image.asset(widget.product.image, width: 45),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("$selectedSize, $currentQuantity Botol", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const Text("Berhasil masuk ke Keranjang!", style: TextStyle(color: Colors.green, fontSize: 11)),
        ]),
      ]),
    );
  }

  Widget _buildModalButtons() {
    return Column(children: [
      SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: armyGreen, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => Navigator.pop(context),
        child: Text("Masukan Keranjang - ${_formatIDR(currentUnitPrice * currentQuantity)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )),
      const SizedBox(height: 10),
      SizedBox(width: double.infinity, child: OutlinedButton(
        style: OutlinedButton.styleFrom(side: BorderSide(color: armyGreen), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())); },
        child: Text("Lanjut Belanja", style: TextStyle(color: armyGreen, fontWeight: FontWeight.bold)),
      )),
    ]);
  }
}