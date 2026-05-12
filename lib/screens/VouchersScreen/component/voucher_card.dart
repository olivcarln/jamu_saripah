import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String expiryDate;
  final String minTransaction;
  final String quota;
  final double discountAmount;
  final VoidCallback onClaim;

  const VoucherCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.expiryDate,
    required this.minTransaction,
    required this.quota,
    required this.discountAmount,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      // Memakai constraints agar fleksibel tapi punya tinggi minimal
      constraints: const BoxConstraints(minHeight: 160), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B6B4D),
            Color(0xFF6B7548),
          ],
        ),
      ),
      child: Stack(
        children: [
          /// NOTCH KIRI (Tetap di tengah secara dinamis)
          Positioned(
            left: -15,
            top: 0,
            bottom: 0,
            child: Center(child: _buildNotch()),
          ),

          /// NOTCH KANAN
          Positioned(
            right: -15,
            top: 0,
            bottom: 0,
            child: Center(child: _buildNotch()),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              // Ini kuncinya: Mendorong konten atas dan bawah agar berjauhan
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BAGIAN ATAS (Dibuat dalam satu grup)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildBrandIcon(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Min. Pembelian $minTransaction",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Potongan Rp ${discountAmount.toInt()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12), // Jarak minimal agar tidak nempel

                /// GARIS PEMISAH
                Container(
                  height: 1,
                  color: Colors.white30,
                ),

                const SizedBox(height: 12), // Jarak minimal

                /// BAGIAN BAWAH
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
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
                    ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: onClaim,
                        child: const Text(
                          "Gunakan",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

  // Widget _buildNotch & _buildBrandIcon tetap sama seperti sebelumnya
  Widget _buildNotch() {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
        child: const Icon(Icons.shopping_bag, color: Colors.white),
      ),
    );
  }
}