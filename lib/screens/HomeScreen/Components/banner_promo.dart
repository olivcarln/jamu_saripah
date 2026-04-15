import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  int _currentIndex = 0;

  // Data promo (Sekarang sudah 3 slide!)
  final List<Map<String, String>> promoData = [
    {
      "title": "Dapatkan Spesial Promo\nCuman Hari ini!",
      "subtitle": "Promo Spesial Hingga 20%",
      "image": "assets/jamu-1.png",
    },
    {
      "title": "Beli 1 Gratis 1\nKhusus Member!",
      "subtitle": "Hanya untuk Beras Kencur",
      "image": "assets/jamu-1.png", // <--- Kamu bisa ganti asset gambarnya kalau ada yang lain
    },
    {
      "title": "Paket Sehat Keluarga\nLebih Hemat!",
      "subtitle": "Diskon Rp 15.000 Tanpa Syarat",
      "image": "assets/jamu-1.png",
    },
  ];
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Promo Menarik!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
<<<<<<< HEAD
        const SizedBox(height: 15),
        CarouselSlider(
          options: CarouselOptions(
            height: 160, // Kunci di 160 biar konsisten
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
=======
        SizedBox(height: 15),

        Container(
          height: 160,
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color:  Color(0xFF7B8D5E),
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/promo_banner.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),

          child: Row(
            children: [
              SizedBox(width: 10),

              // 👈 gambar kiri
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/jamu-1.png',
                  fit: BoxFit.contain,
                ),
              ),

              // 👉 konten kanan
              Expanded(
                flex: 2,
                child: Padding(
                  padding:EdgeInsets.symmetric(
                    vertical: 10, // 👈 DIKECILIN BIAR GA OVERFLOW
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 👈 WAJIB
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color:  Color(0xFFB24D4D),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Flash Sale!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                       SizedBox(height: 6),

                      Text(
                        "Dapatkan Spesial Promo\nCuman Hari ini!",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13, // 👈 DIKECILIN DIKIT
                        ),
                      ),

                       SizedBox(height: 4),

                      Text(
                        "Promo Spesial Hingga 20%",
                        style: TextStyle(
                          color: Color(0xFFE8D28E),
                          fontSize: 11, // 👈 DIKECILIN
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color:  Color(0xFF634E34),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Order Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
>>>>>>> 95ec7f187c1d05560bc5391c610b074ae43a40a9
          ),
          items: promoData.map((data) => _buildBannerCard(data)).toList(),
        ),
<<<<<<< HEAD
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promoData.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == entry.key ? 15 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key ? const Color(0xFF634E34) : Colors.grey.shade300,
=======

       SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: index == 0 ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 0
                    ? Color(0xFF634E34)
                    : Colors.grey.shade300,
>>>>>>> 95ec7f187c1d05560bc5391c610b074ae43a40a9
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerCard(Map<String, String> data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF7B8D5E),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/promo_banner.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Row( // Pakai Row biar pembagian tempatnya adil
        children: [
          // Kiri: Gambar
          Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              data['image']!,
              width: 90,
              fit: BoxFit.contain,
            ),
          ),
          
          // Kanan: Teks (Dikasih Expanded biar nggak overflow)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB24D4D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Flash Sale!",
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Kalau kepanjangan jadi titik-titik
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    data['subtitle']!,
                    style: const TextStyle(color: Color(0xFFE8D28E), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Tombol yang bisa diklik
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => print("Clicked!"),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF634E34),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "Order Now",
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}