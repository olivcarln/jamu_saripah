import 'package:flutter/material.dart';

class ProductOptionsSection extends StatefulWidget {
  final String productName;
  final Function(String)? onSizeChanged;
  final Function(String)? onOptionChanged; // Tambahkan callback untuk opsi
  final bool isBundle; // Tambahkan parameter isBundle

  const ProductOptionsSection({
    super.key, 
    required this.productName,
    this.onSizeChanged,
    this.onOptionChanged, // Tambahkan ke constructor
    this.isBundle = false, // Default false agar UI lama tidak berubah
  });

  @override
  State<ProductOptionsSection> createState() => _ProductOptionsSectionState();
}

class _ProductOptionsSectionState extends State<ProductOptionsSection> {
  String selectedSize = "250 ml"; // Sesuaikan default ke 250ml agar sinkron
  int selectedOption = 1;        

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
          
          Row(
            children: [
              _buildSizeOption("250 ml"),
              const SizedBox(width: 10),
              _buildSizeOption("350 ml"),
              const SizedBox(width: 10),
              _buildSizeOption("1 Liter"),
            ],
          ),
          
          // LOGIKA: Jika isBundle true (Paket Mix), maka section pilihan di bawah ini hilang
          if (!widget.isBundle) ...[
            const SizedBox(height: 25),
            const Text(
              "Pilihan Tersedia", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("${widget.productName} Saja"),
              trailing: Radio<int>(
                value: 1,
                groupValue: selectedOption,
                activeColor: const Color(0xFF7E8959),
                onChanged: (val) {
                  setState(() {
                    selectedOption = val!;
                  });
                  // Kirim balik teks pilihan ke DetailScreen
                  if (widget.onOptionChanged != null) {
                    widget.onOptionChanged!("${widget.productName} Saja");
                  }
                },
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Paket 3 Botol ${widget.productName}"),
              trailing: Radio<int>(
                value: 2,
                groupValue: selectedOption,
                activeColor: const Color(0xFF7E8959),
                onChanged: (val) {
                  setState(() {
                    selectedOption = val!;
                  });
                  // Kirim balik teks pilihan ke DetailScreen untuk trigger harga 70rb
                  if (widget.onOptionChanged != null) {
                    widget.onOptionChanged!("Paket 3 Botol ${widget.productName}");
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSizeOption(String label) {
    bool isSelected = selectedSize == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = label;
        });
        if (widget.onSizeChanged != null) {
          widget.onSizeChanged!(label);
        }
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