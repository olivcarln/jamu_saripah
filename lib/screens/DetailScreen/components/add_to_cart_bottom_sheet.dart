import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/product_cart.dart'; // ✅ WAJIB: Biar kenal tipe data Product

class AddToCartBottomSheet extends StatefulWidget {
  // ✅ 1. TAMBAHIN INI: Biar DetailScreen bisa ngirim data ke sini
  final Product product;
  final int quantity;
  final String size;

  const AddToCartBottomSheet({
    super.key,
    required this.product, // ✅ Sekarang parameter ini "Defined"
    required this.quantity,
    required this.size,
  });

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  // ✅ 2. Inisialisasi state pake data awal yang dikirim dari DetailScreen
  late String selectedSize;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.size; // Pake size yang dipilih user di screen sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),
          
          const Text(
            "Lengkapi Belanjamu", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7E8959))
          ),
          const SizedBox(height: 20),

          // Kartu Item
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                // ✅ Pake gambar dinamis dari product
                Image.asset(widget.product.image, width: 50, height: 50),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Pake nama dinamis dari product
                      Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedSize, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const Text("Berhasil masuk ke Keranjang!", style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orange, size: 18),
              SizedBox(width: 8),
              Text("Ssst...ubah ukuran jamu jadi lebih besar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _buildSizeOption("250 ml"),
              const SizedBox(width: 8),
              _buildSizeOption("350 ml"),
              const SizedBox(width: 8),
              _buildSizeOption("1 Liter"),
            ],
          ),

          const SizedBox(height: 30),

          // Tombol Masukan Keranjang
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E8959),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                // ✅ Kalkulasi harga dinamis (widget.product.price * widget.quantity)
                "Masukan Keranjang - ${formatCurrency.format(widget.product.price * widget.quantity)}", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFF7E8959)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Lanjut Belanja", style: TextStyle(color: Color(0xFF7E8959), fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String label) {
    bool isSelected = selectedSize == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedSize = label;
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E8959) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}