import 'package:flutter/material.dart';

class SelectMethodScreen extends StatefulWidget {
  const SelectMethodScreen({super.key});

  @override
  State<SelectMethodScreen> createState() => _SelectMethodScreenState();
}

class _SelectMethodScreenState extends State<SelectMethodScreen> {
  int _selectedMethod = 2; // Default ke Delivery (value 2)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pilih metode",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildMethodItem(
              value: 1,
              title: "Pick Up",
              subtitle: "Datang, ambil, beres!",
              icon: Icons.person_pin_circle_outlined,
            ),
            const SizedBox(height: 20),
            _buildMethodItem(
              value: 2,
              title: "Delivery",
              subtitle: "Tinggal pesan, kami yang antar",
              icon: Icons.delivery_dining_outlined,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Kirim balik String sesuai pilihan
                  String methodToReturn = _selectedMethod == 1 ? 'Pick Up' : 'Delivery';
                  Navigator.pop(context, methodToReturn);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E4E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  "Ubah Metode",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem({required int value, required String title, required String subtitle, required IconData icon}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(color: Color(0xFFD4DBB9), shape: BoxShape.circle),
              child: Icon(icon, size: 30, color: const Color(0xFF6B8E4E)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6B4226))),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B8E4E))),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6B8E4E), width: 2),
              ),
              child: _selectedMethod == value
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(color: Color(0xFF6B8E4E), shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}