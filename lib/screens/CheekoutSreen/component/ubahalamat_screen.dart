import 'package:flutter/material.dart';

class UbahAlamatScreen extends StatefulWidget {
  const UbahAlamatScreen({super.key});

  @override
  State<UbahAlamatScreen> createState() => _UbahAlamatScreenState();
}

class _UbahAlamatScreenState extends State<UbahAlamatScreen> {
  // Default value
  String selectedMethod = 'delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Metode',
          style: TextStyle(color: Colors.black, 
          fontWeight: FontWeight.w900,
           fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  _buildMethodItem(
                    title: 'Pick Up',
                    subtitle: 'datang, ambil, beres!',
                    value: 'pick up',
                    icon: Icons.people_outline, 
                    titleColor: const Color(0xFF8B4513),
                  ),

                  const SizedBox(height: 20),

                  _buildMethodItem(
                    title: 'Delivery',
                    subtitle: 'tinggal pesan, kami yang antar',
                    value: 'delivery',
                    icon: Icons.local_shipping_outlined,
                    titleColor: const Color(0xFF5D8C3F),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Diperkecil dari 55
              child: ElevatedButton(
                onPressed: () {
                  // Mengirim data selectedMethod kembali ke CheckoutScreen
                  Navigator.pop(context, selectedMethod);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF76894F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  'ubah metode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodItem({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color titleColor,
  }) {
    bool isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // Ukuran lingkaran diperkecil dari 75 ke 55
          Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E9C8),
              shape: BoxShape.circle,
            ),
            // Ukuran icon diperkecil dari 35 ke 24
            child: Icon(icon, size: 24, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18, // Diperkecil dari 22
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Radio button custom diperkecil
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF76894F), width: 2),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF76894F),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}