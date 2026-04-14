import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // 1. Bagian Atas (Lokasi & Icon)
            _buildTopBar(),
            const SizedBox(height: 20),
            
            // 2. Search Bar
            _buildSearchBar(),
            const SizedBox(height: 30),
            
            // 3. Kartu Poin (Ini yang isinya 100 Points + Gambar Koin)
            _buildPointCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Location", style: TextStyle(color: Colors.white70, fontSize: 10)),
            Text("Jakarta, Indonesia", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
         Icon(Icons.notifications, color: Colors.white),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPointCard() {
  return Container(
    // Kita atur padding supaya konten teks gak kepentok pinggir
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      clipBehavior: Clip.none, // Biar kalau gambar koinnya agak keluar dikit gak kepotong
      children: [
        // --- LAYER 1: Gambar Koin di Background Kanan ---
        Positioned(
          right: -10, // Sesuaikan biar koinnya mepet atau agak keluar ke kanan
          top: -25,   // Biar koinnya agak naik ke atas seperti di desain
          child: Image.asset(
            'assets/Coints.svg', // Ganti dengan nama file koin kamu
            width: 50, // Atur ukuran grup koinnya
          ),
        ),

        // --- LAYER 2: Konten Teks ---
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge 100 Points
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF5E6), // Kuning krem
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37), width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.monetization_on, color: Color(0xFFD4AF37), size: 18),
                  SizedBox(width: 6),
                  Text(
                    "100 Points",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.black12),
            const SizedBox(height: 12),

            // Teks Info Redeem
            Row(
              children: const [
                Text(
                  "Redeem your points for exciting rewards",
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 12, color: Colors.black54),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
}