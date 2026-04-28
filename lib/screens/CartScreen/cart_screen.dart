import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _formatIDR(int amount) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    final items = provider.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keranjang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E8959), // Hijau Army Figma
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header Pilih Semua
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Checkbox(
                  value: provider.isAllChecked,
                  activeColor: const Color(0xFF7E8959),
                  onChanged: (val) => provider.checkAll(val!),
                ),
                const Text("Pilih semua", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                
                // ✅ LOGIC LU TETEP KEPKE TAPI UI-NYA GUE CAKEPIN
                return CartItem(
                  item: item,
                  onToggle: () => setState(() => provider.checkItem(index, !item.isChecked)),
                  onIncrement: () => setState(() => provider.incrementQuantity(index)),
                  onDecrement: () {
                    if (item.quantity > 1) {
                      setState(() => provider.decrementQuantity(index));
                    }
                  },
                );
              },
            ),
          ),
          // FOOTER TOTAL & TOMBOL COKLAT
          _buildFooter(provider),
        ],
      ),
    );
  }

  // ✅ INI WIDGET CARTITEM NYA (Gue taruh sini biar lu gak perlu file baru)
  Widget CartItem({
    required dynamic item,
    required VoidCallback onToggle,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Fix typo EdgeInsets
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            activeColor: const Color(0xFF7E8959),
            onChanged: (val) => onToggle(),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.image, width: 75, height: 75, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(item.size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatIDR(item.price), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7E8959))),
                    // Counter Quantity
                    Row(
                      children: [
                        IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove_circle_outline, size: 20)),
                        Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(onPressed: onIncrement, icon: const Icon(Icons.add_circle, size: 20, color: Color(0xFF7E8959))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(CartProvider provider) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total (${provider.checkedItemsCount} item):", style: const TextStyle(color: Color(0xFF7E8959), fontSize: 12)),
              Text(_formatIDR(provider.checkedTotalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7E8959))),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B6B4C), // Coklat Figma
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}