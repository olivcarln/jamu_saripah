import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/detail_profile_screen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // PROFILE CARD
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: InkWell( // Menggunakan InkWell agar ada efek ripple saat diklik
    onTap: () {
      // Navigasi ke DetailProfilePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DetailProfilePage(),
        ),
      );
    },
    borderRadius: BorderRadius.circular(16), // Supaya efek klik sesuai bentuk border
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6E8B4F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/profile.svg',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Naiput", // Nanti ini bisa dioper via constructor jika perlu
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "+621234567890123",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
        ],
      ),
    ),
  ),
),

            const SizedBox(height: 20),

            // GREY BOX (placeholder)

            // MENU LIST
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(color: Colors.white),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    buildMenuItem("Alamat Tersimpan"),
                    buildMenuItem("Pembayaran"),
                    buildMenuItem("Pusat Bantuan"),
                    buildMenuItem("Pengaturan"),
                    buildMenuItem("Syarat & Ketentuan"),
                    buildMenuItem("Kebijakan Privasi"),
                    buildMenuItem("Media Sosial"),

                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        "Version 1.0.0",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const Divider(),
      ],
    );
  }
}
