import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

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
        
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF7B8D5E), 
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('assets/promo_banner.png'), 
              fit: BoxFit.cover,
              opacity: 0.15, 
            ),
          ),
          
          child: Stack(
            children: [
              Positioned(
                left: 10,
                bottom: 10,
                top: 10,
                child: Image.asset(
                  'assets/jamu-1.png', 
                  fit: BoxFit.contain,
                ),
              ),

              Positioned(
                right: 20,
                top: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB24D4D), 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Flash Sale!",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Dapatkan Spesial Promo\nCuman Hari ini!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Promo Spesial Hingga 20%",
                      style: TextStyle(
            color: Color(0xFFE8D28E), 
            fontSize: 12, 
            fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == 0 ? 12 : 8, 
              height: 8,
              decoration: BoxDecoration(
                color: index == 0 ? const Color(0xFF634E34) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}