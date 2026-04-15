import 'package:flutter/material.dart';

class OrderMethod extends StatelessWidget {
  final String userName;
  final VoidCallback onPickUpTap;
  final VoidCallback onDeliveryTap;

  const OrderMethod({
    super.key,
    required this.userName,
    required this.onPickUpTap,
    required this.onDeliveryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Hi $userName, Ready to Order?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildMethodCard(
                  title: "Pickup", // Lu bisa ganti jadi "Pick Up"
                  subtitle: "Pesan sekarang untuk dinikmati nanti.",
                  imagePath: "assets/pickup.png",
                  onTap: onPickUpTap,
                ),
                const SizedBox(width: 15),
                _buildMethodCard(
                  title: "Delivery",
                  subtitle: "Kami antar jamu segar ke pintumu.",
                  imagePath: "assets/delivery.png",
                  onTap: onDeliveryTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // 1. GAMBAR (Ini patokan sizenya)
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.contain, 
                ),
                
                // 2. TEKS (Nempel di atas gambar)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // Efek pudar estetik sesuai contoh lu
                          color: const Color(0xFF5E6D45).withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 85, // Biar teks gak nabrak ilustrasi orangnya
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.black.withValues(alpha: 0.4),
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}