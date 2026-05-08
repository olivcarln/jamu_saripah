import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';

class VoucherHeader extends StatefulWidget {
  final bool isVoucherActive;
  final VoidCallback? onVoucherTap;
  final VoidCallback? onPaydayTap;

  const VoucherHeader({
    super.key,
    this.isVoucherActive = true,
    this.onVoucherTap,
    this.onPaydayTap,
  });

  @override
  State<VoucherHeader> createState() => _VoucherHeaderState();
}

class _VoucherHeaderState extends State<VoucherHeader> {
  // Warna disesuaikan dengan tema Jamu Saripah di gambar
  final primaryColor = const Color(0xFF6E864C); 
  final textColor = Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background putih bersih sesuai gambar
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE "Vouchers" (Bold & Center)
          Center(
            child: Text(
              "Vouchers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOlive,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// INPUT PROMO BOX
     Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Padding vertikal dikurangi biar pas
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
  ),
  child: Row(
    children: [
      Icon(Icons.local_offer_outlined, color: primaryColor, size: 24),
      const SizedBox(width: 12),
      Expanded(
        child: TextField(
          // Tambahkan controller di sini kalau mau ambil datanya nanti
          // controller: promoController, 
          decoration: InputDecoration(
            hintText: "Dapat kode promo? masukkan disini",
            hintStyle: TextStyle(
              color: primaryColor.withOpacity(0.6),
              fontSize: 15,
            ),
            border: InputBorder.none, // Menghilangkan garis bawah bawaan TextField
            isDense: true, // Membuat tinggi TextField lebih ramping
          ),
          style: TextStyle(
            color: primaryColor,
            fontSize: 15,
          ),
        ),
      ),
    ],
  ),
),
          
          const SizedBox(height: 25),

          /// TAB MENU (Vouchers)
          GestureDetector(
            onTap: widget.onVoucherTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vouchers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOlive, // Warna coklat sesuai gambar
                  ),
                ),
                const SizedBox(height: 4),
                // Garis bawah (Underline)
                Container(
                  height: 3,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOlive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}