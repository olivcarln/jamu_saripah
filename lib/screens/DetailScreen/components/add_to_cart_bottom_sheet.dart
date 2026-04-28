import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddToCartBottomSheet extends StatefulWidget {
  final int price; 
  final Function(int) onAddToCart;

  const AddToCartBottomSheet({super.key, required this.price, required this.onAddToCart});

  @override
  State<AddToCartBottomSheet> createState() => _AddCartBottomState();
}

class _AddCartBottomState extends State<AddToCartBottomSheet> {
  int quantity = 1;

  String _formatIDR(int amount) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                IconButton(onPressed: () { if (quantity > 1) setState(() => quantity--); }, icon: const Icon(Icons.remove, size: 20)),
                Text("$quantity", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add, color: Color(0xFF7E8959), size: 20)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7E8959), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              onPressed: () => widget.onAddToCart(quantity),
              child: Text("Tambah - ${_formatIDR(widget.price * quantity)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}