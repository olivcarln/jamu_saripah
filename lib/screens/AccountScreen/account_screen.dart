import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/help_center_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/payment_method_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/privacy_police_screen.dart';
import 'package:jamu_saripah/screens/SettingsScreen/settings_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/tems_conditions_screen.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/detail_profile_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;

  // --- LOGIC: BUKA INSTAGRAM ---
  Future<void> _launchInstagram() async {
    const String url = "https://www.instagram.com/jamusaripah?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==";
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak dapat membuka Instagram"), backgroundColor: Colors.red),
        );
      }
    }
  }

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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailProfileScreen())),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E8B4F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                   StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .snapshots(),
  builder: (context, snapshot) {

    String? base64Image;

    if (snapshot.hasData && snapshot.data!.exists) {
      final data =
          snapshot.data!.data() as Map<String, dynamic>?;

      base64Image = data?['photoBase64'];
    }

    Uint8List? imageBytes;

    if (base64Image != null &&
        base64Image.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image);
      } catch (e) {
        imageBytes = null;
      }
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.transparent,

      backgroundImage: imageBytes != null
          ? MemoryImage(imageBytes)
          : null,

      child: imageBytes == null
          ? ClipOval(
              child: SvgPicture.asset(
                'assets/profile.svg',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            )
          : null,
    );
  },
),
                      const SizedBox(width: 12),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          final data = snapshot.data!.data() as Map<String, dynamic>?;
                          final namaUser = data?['name'] ?? 'User';
                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(namaUser, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text("Lihat Profil", style: TextStyle(color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
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
                    buildMenuItem("Pembayaran", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodScreen()))),
                    buildMenuItem("Pusat Bantuan", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()))),
                    buildMenuItem("Pengaturan", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))),
                    buildMenuItem("Syarat & Ketentuan", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()))),
                    buildMenuItem("Kebijakan Privasi", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()))),
                    
                    // --- MENU MEDIA SOSIAL DENGAN LOGO INSTAGRAM ---
                    buildMenuItem(
                      "Media Sosial",
                      onTap: _launchInstagram,
                      isInstagram: true, // Trigger logo Instagram
                    ),
                    
                    const SizedBox(height: 60),
                    const Center(child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE MENU ITEM ---
  Widget buildMenuItem(String title, {VoidCallback? onTap, bool isInstagram = false}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: isInstagram
              ? Container(
                  padding: const EdgeInsets.all(2),
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png',
                    width: 24,
                    height: 24,
                  ),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}