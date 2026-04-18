import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';
import 'package:jamu_saripah/screens/main_screen.dart';

class PaydayScreen extends StatelessWidget {
  const PaydayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 🔥 WAJIB biar ga blank
      body: Column(
        children: [
          // HEADER
          VoucherHeader(
            isVoucherActive: false, // ✅ Payday aktif
            onVoucherTap: () {
              Navigator.pop(context); 
            },
            onPaydayTap: () {
              // lagi di Payday → ga usah ngapa-ngapain
            },
          ),

          Divider(height: 1),

          // CONTENT PAYDAY
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => VoucherCard(),
            ),
          ),
        ],
      ),
bottomNavigationBar: BottomNav(
        currentIndex: 1, // Tetap 1 karena Payday masih bagian dari menu Voucher
        onTap: (index) {
          if (index == 1) {
            Navigator.pop(context); // Jika klik Voucher lagi, balik ke Voucher utama
          } else {
            // Jika klik Home, History, atau Profile:
            // 1. Tutup PaydayScreen dulu
            // 2. Di MainScreen otomatis ganti index (lewat callback atau pushReplacement ke Main)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          }
        },
      ),   );
  }
}