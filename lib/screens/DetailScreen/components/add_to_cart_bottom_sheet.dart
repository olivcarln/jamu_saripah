import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/product_cart.dart'; 

class AddToCartBottomSheet extends StatefulWidget {
  final Product product;
  final int quantity;
  final String size;

  const AddToCartBottomSheet({
    super.key,
    required this.product,
    required this.quantity,
    required this.size,
  });

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  String selectedSize = "";
  int currentPrice = 0;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.size;
    _calculatePrice(widget.size);
  }

  // ✅ DUMMY PRICE LOGIC (Sesuai Paket & Ukuran)
  void _calculatePrice(String size) {
    // Kita cek apakah nama produknya mengandung kata "Paket"
    bool isPaket = widget.product.name.contains("Paket");

    if (isPaket) {
      // Harga khusus kalau user pilih Paket 3 Botol
      if (size == "250 ml") {
        currentPrice = 60000; // Contoh: Paket 250ml
      } else if (size == "350 ml") {
        currentPrice = 65000; // Contoh: Paket 350ml
      } else if (size == "1 Liter") {
        currentPrice = 70000; // Sesuai screenshot lu!
      }
    } else {
      // Harga kalau beli satuan (Bukan Paket)
      int basePrice = widget.product.price;
      if (size == "350 ml") {
        currentPrice = basePrice + 5000;
      } else if (size == "1 Liter") {
        currentPrice = basePrice + 15000;
      } else {
        currentPrice = basePrice;
      }
    }
  }

  void _updateLocalPrice(String size) {
    setState(() {
      selectedSize = size;
      _calculatePrice(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );

    int totalHarga = currentPrice * widget.quantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),
          
          const Text(
            "Lengkapi Belanjamu", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7E8959))
          ),
          const SizedBox(height: 20),

          // Kartu Item (UI LU TETEP SAMA)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!), 
              borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              children: [
                Image.asset(widget.product.image, width: 50, height: 50),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedSize, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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

          // Option Selection (UI LU TETEP SAMA)
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.product.name} ($selectedSize) ditambahkan!"),
                    backgroundColor: const Color(0xFF7E8959),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                "Masukan Keranjang - ${formatCurrency.format(totalHarga)}", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // Tombol Lanjut Belanja (Navigate ke Home)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFF7E8959)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Beres! Langsung ke Home dan stack dibersihin
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
              },
              child: const Text("Lanjut Belanja", style: TextStyle(color: Color(0xFF7E8959), fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ✅ UI Selection (TETEP PAKE INKWELL LU)
  Widget _buildSizeOption(String label) {
    bool isSelected = selectedSize == label;

    return InkWell(
      onTap: () => _updateLocalPrice(label),
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