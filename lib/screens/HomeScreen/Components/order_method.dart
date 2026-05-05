import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
       Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Text.rich(
    TextSpan(
      text: "Hi ",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      children: [
        TextSpan(
          text: userName,
          style: const TextStyle(
            color: Color(0xFF5E6D45), // ✅ warna ijo
          ),
        ),
        const TextSpan(
          text: ", siap hidup sehat?",
        ),
      ],
    ),
  ),
),

          const SizedBox(height: 15),

          // Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildMethodCard(
                  title: "Pick up",
                  subtitle: "Pesan sekarang, nikmati nanti.",
                  imagePath: "assets/pickup_button.svg",
                  onTap: onPickUpTap,
                ),
                const SizedBox(width: 15),
                _buildMethodCard(
                  title: "Delivery",
                  subtitle: "Kami antar jamu segar ke pintumu.",
                  imagePath: "assets/delivery_button.svg",
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
        // Menyesuaikan shadow dan border radius luar
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Lebih melengkung sesuai foto
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 120, // Sedikit lebih tinggi agar proposional
            child: Stack(
              children: [
                // 🔥 TEXT CONTENT (Diletakkan di bawah gambar agar gambar bisa overlay jika perlu)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22, // Lebih besar sesuai foto
                          fontWeight: FontWeight.w800, // Extra bold
                          color: Color(0xFF6E864C),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Membatasi lebar teks agar tidak menabrak gambar di kanan
                      SizedBox(
                        width: 100, 
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.3,
                            color: Color(0xFF8A9A73), // Warna teks hijau pudar
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 IMAGE (Di posisi kanan bawah)
                Positioned(
                  right: -10, // Sedikit keluar container
                  bottom: -5,  // Menempel ke bawah
                  child: SvgPicture.asset(
                    imagePath,
                        width: title == "Pick up" ? 88 : 75, // ✅ pickup lebih gede
 // Ukuran disesuaikan agar dominan di kanan
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}