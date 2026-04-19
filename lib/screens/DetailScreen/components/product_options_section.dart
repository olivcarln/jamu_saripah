import 'package:flutter/material.dart';

class ProductOptionsSection extends StatefulWidget {
  const ProductOptionsSection({super.key});

  @override
  State<ProductOptionsSection> createState() => _ProductOptionsSectionState();
}

class _ProductOptionsSectionState extends State<ProductOptionsSection> {
  // Variabel buat nyimpen pilihan user
  String selectedSize = "350 ml"; // Default ukuran
  int selectedOption = 1;         // Default pilihan paket

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ukuran Tersedia", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
          ),
          const SizedBox(height: 15),
          
          // Row Ukuran
          Row(
            children: [
              _buildSizeOption("250 ml"),
              const SizedBox(width: 10),
              _buildSizeOption("350 ml"),
              const SizedBox(width: 10),
              _buildSizeOption("1 Liter"),
            ],
          ),
          
          const SizedBox(height: 25),
          const Text(
            "Pilihan Tersedia", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
          ),

          // Opsi Radio 1
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Beras Kencur Saja"),
            trailing: Radio<int>(
              value: 1,
              // ignore: deprecated_member_use
              groupValue: selectedOption,
              activeColor: const Color(0xFF7E8959),
              // ignore: deprecated_member_use
              onChanged: (val) {
                setState(() {
                  selectedOption = val!;
                });
              },
            ),
          ),

          // Opsi Radio 2
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Paket 3 Botol Beras Kencur"),
            trailing: Radio<int>(
              value: 2,
              // ignore: deprecated_member_use
              groupValue: selectedOption,
              activeColor: const Color(0xFF7E8959),
              // ignore: deprecated_member_use
              onChanged: (val) {
                setState(() {
                  selectedOption = val!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Button Ukuran yang bisa berubah warna
  Widget _buildSizeOption(String label) {
    bool isSelected = selectedSize == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E8959) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}