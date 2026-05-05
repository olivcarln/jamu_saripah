import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggle;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggle,
  });

  // Fungsi format rupiah lokal biar nggak error
  String _formatRupiah(int amount) {
    String strAmount = amount.toString();
    String result = "";
    int count = 0;
    for (int i = strAmount.length - 1; i >= 0; i--) {
      result = strAmount[i] + result;
      count++;
      // ignore: prefer_interpolation_to_compose_strings
      if (count % 3 == 0 && i != 0) result = "." + result;
    }
    return "Rp $result";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          // CHECKBOX
          GestureDetector(
            onTap: onToggle, // Panggil fungsi dari luar
            child: Icon(
              item.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: const Color(0xFF7E8959),
            ),
          ),
          const SizedBox(width: 12),
          // GAMBAR PRODUK
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.image, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          // DETAIL TEKS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatRupiah(item.price),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    
                    // COUNTER PLUS MINUS
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(Icons.remove, onDecrement),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildQtyBtn(Icons.add, onIncrement),
                        ],
                      ),
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

  // Tombol kecil buat + dan -
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color(0xFF7E8959),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}