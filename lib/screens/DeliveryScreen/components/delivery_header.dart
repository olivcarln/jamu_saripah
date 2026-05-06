import 'package:flutter/material.dart';

class DeliveryHeader extends StatelessWidget {
  final VoidCallback onBack;

  const DeliveryHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 50, // sedikit lebih turun biar aman
        left: 16,
        right: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF7E8959),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔙 BACK BUTTON
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),

           SizedBox(width: 10),

          // 🚚 ICON
          const Icon(
            Icons.delivery_dining,
            color: Colors.white,
            size: 34,
          ),

          const SizedBox(width: 10),

          // 📝 TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                "Kami antar ke rumahmu",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}