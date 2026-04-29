import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
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
            const SizedBox(height: 10),
            // PROFILE CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailProfilePage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
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
                              "Naiput",
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
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MENU LIST
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(color: Colors.white),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    buildMenuItem(context, "Alamat Tersimpan"),
                    
                    // MENU PEMBAYARAN DENGAN NAVIGASI
                    buildMenuItem(
                      context, 
                      "Pembayaran",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(),
                          ),
                        );
                      },
                    ),
                    
                    buildMenuItem(context, "Pusat Bantuan"),
                    buildMenuItem(context, "Pengaturan"),
                    buildMenuItem(context, "Syarat & Ketentuan"),
                    buildMenuItem(context, "Kebijakan Privasi"),
                    buildMenuItem(context, "Media Sosial"),

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

  // MODIFIKASI FUNGSI: Menambahkan parameter onTap
  Widget buildMenuItem(BuildContext context, String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap ?? () {}, // Jika tidak ada aksi, biarkan kosong
        ),
        const Divider(),
      ],
    );
  }
}