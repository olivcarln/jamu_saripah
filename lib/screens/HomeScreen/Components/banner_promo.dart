import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

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
          ),
        ),

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
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}