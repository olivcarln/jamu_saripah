import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String expiryDate;
  final String minTransaction;
  final String quota;
  final VoidCallback onClaim;

  const VoucherCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.expiryDate,
    required this.minTransaction,
    required this.quota,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 160, // Sesuaikan tinggi agar notch pas di tengah garis
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B6B4D), // Coklat muda
            Color(0xFF6B7548), // Hijau army
          ],
        ),
      ),
      child: Stack(
        children: [
          /// NOTCH KIRI (Lingkaran Putih)
          Positioned(
            left: -15,
            top: 65, // Letakkan pas di garis pemisah
            child: _buildNotch(),
          ),

          /// NOTCH KANAN (Lingkaran Putih)
          Positioned(
            right: -15,
            top: 65,
            child: _buildNotch(),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BAGIAN ATAS (Judul & Icon)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subTitle, // Diskon 35%...
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Min. Pembelian $minTransaction",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Bundar dengan Gambar Tas
                    _buildBrandIcon(),
                  ],
                ),

                const Spacer(),
                
                /// GARIS PEMISAH (Dashed/Solid Line)
                Container(
                  height: 1,
                  color: Colors.white30,
                ),
                
                const Spacer(),

                /// BAGIAN BAWAH (Expired & Tombol)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Berlaku Sampai',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expiryDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    /// TOMBOL GUNAKAN
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6B7548),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        onPressed: onClaim,
                        child: const Text(
                          "Gunakan Voucher",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotch() {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        color: Colors.white, // Sesuaikan dengan warna background screen
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBrandIcon() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          'assets/images/voucher_icon.png', // Ganti dengan path icon kamu
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.shopping_bag,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}