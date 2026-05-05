import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor:Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          // TITLE
          const Text(
            "Pertanyaan Umum",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

    
          buildSectionTitle("Akun"),
          buildFAQ(
            "Bagaimana cara mengubah data profil?",
            "Masuk ke halaman profil, lalu klik edit untuk mengubah data.",
          ),
          buildFAQ(
            "Saya lupa password, bagaimana cara reset?",
            "Klik 'Lupa Password' di halaman login.",
          ),

         
          buildSectionTitle("Alamat"),
          buildFAQ(
            "Bagaimana cara menambah alamat?",
            "Masuk ke menu alamat tersimpan lalu klik tambah alamat.",
          ),
          buildFAQ(
            "Bisa simpan lebih dari satu alamat?",
            "Bisa, kamu bebas menambahkan beberapa alamat.",
          ),

          // 🛒 PESANAN
          buildSectionTitle("Pesanan"),
          buildFAQ(
            "Bagaimana cara melihat status pesanan?",
            "Cek di menu Pesanan untuk status realtime.",
          ),
          buildFAQ(
            "Kenapa pesanan saya belum sampai?",
            "Kemungkinan masih dalam proses pengiriman.",
          ),

          // 💳 PEMBAYARAN
          buildSectionTitle("Pembayaran"),
          buildFAQ(
            "Metode pembayaran apa saja?",
            "Transfer bank, e-wallet, dan COD.",
          ),
          buildFAQ(
            "Pembayaran gagal?",
            "Cek saldo & koneksi internet lalu coba lagi.",
          ),

          const SizedBox(height: 30),

          // 📞 BUTTON UPGRADE
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.headset_mic),
            label: const Text("Hubungi Kami"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOlive,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 SECTION TITLE
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOlive,
        ),
      ),
    );
  }

  // 🔥 FAQ UPGRADE
  Widget buildFAQ(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          children: [
            Text(
              answer,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}