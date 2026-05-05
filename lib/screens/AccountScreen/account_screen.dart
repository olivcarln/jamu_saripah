import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/help_center_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/payment_method_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/privacy_police_screen.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/saved_address_screen.dart';
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
                      builder: (context) => const DetailProfileScreen(),
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
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();

                          final data = snapshot.data!.data() as Map<String, dynamic>?;
                          final namaUser = data?['name'] ?? 'User';

                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaUser,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Lihat Profil",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
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
                    buildMenuItem(
                      "Alamat Tersimpan",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedAddress(),
                          ),
                        );
                      },
                    ),
                    buildMenuItem("Pembayaran",
                          onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentMethodScreen(),
                          ),
                        );
                      },),
                    buildMenuItem("Pusat Bantuan",  onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpCenterScreen(),
                          ),
                        );
                      },),
                    buildMenuItem("Pengaturan",
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen()
                          ),
                        );
                    },
                    ),
                    buildMenuItem(
                      "Syarat & Ketentuan",
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsConditionsScreen()
                            )
                            );
                      },
                      ),
                    buildMenuItem("Kebijakan Privasi",
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder :(context) => PrivacyPolicyScreen()
                          )
                        );
                    },
                    
                    ),
                    buildMenuItem("Media Sosial"),
                    const SizedBox(height: 60),
                    const Center(
                      child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
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

  // Fungsi buildMenuItem yang sudah diperbaiki agar bisa menerima onTap
  Widget buildMenuItem(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap ?? () {}, // Jika onTap kosong, tidak melakukan apa-apa
        ),
        const Divider(),
      ],
    );
  }
}
