import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  int _currentIndex = 0;

  final List<Map<String, String>> promoData = [
    {
      "title": "Dapatkan Spesial Promo\nCuman Hari ini!",
      "subtitle": "Promo Spesial Hingga 20%",
      "image": "assets/jamu-1.png",
    },
    {
      "title": "Beli 1 Gratis 1\nKhusus Member!",
      "subtitle": "Hanya untuk Beras Kencur",
      "image": "assets/jamu-1.png",
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Promo Menarik!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        
        // Pakai Carousel (Punya kamu)
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: promoData.map((data) => _buildBannerCard(data)).toList(),
        ),

        const SizedBox(height: 12),
        
        // Dot Indikator yang sinkron sama jumlah data
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promoData.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == entry.key ? 15 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key 
                    ? const Color(0xFF634E34) 
                    : Colors.grey.shade300,
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
          opacity: 0.15, // Disesuaikan sama punya Echa biar cantik
        ),
      ),
      child: Row(
        children: [
          // Gambar Kiri
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                data['image']!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          // Konten Kanan
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB24D4D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Flash Sale!",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 13
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['subtitle']!,
                    style: const TextStyle(
                      color: Color(0xFFE8D28E), 
                      fontSize: 11, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF634E34),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "Order Now",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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