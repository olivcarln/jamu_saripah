import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/HomeScreen/Components/banner_promo.dart';
import 'Components/home_header.dart';
import 'Components/order_method.dart'; // Nama komponen sesuai request kamu
import 'Components/home_recommended.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. DATA DINAMIS (Bisa diambil dari Database nantinya)
  String userName = "Naiput";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 2. BOTTOM NAVIGATION BAR (Warna Hijau Tema)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:  Color(0xFF7B8D5E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: "Vouchers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Your order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
      ),

      // 3. BODY DENGAN SCROLL
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BAGIAN ATAS (Header & Point Card)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // --- GANTI CONTAINER HIJAU POLOS DENGAN INI ---
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/banner.png',
                      ), 
                      fit: BoxFit
                          .cover, // Biar gambarnya nge-pas menutupi area atas
                    ),
                  ),
                ),

                // Header (isinya Location & Search bar) tetap di atasnya
                const HomeHeader(),
              ],
            ),
            // JARAK ANTARA POINT CARD KE PROMO
            const SizedBox(height: 85),

            // KOMPONEN BANNER PROMO (Flash Sale)
            const PromoBanner(),

            const SizedBox(height: 25),

            // KOMPONEN ORDER METHOD (Pick Up & Delivery)
            OrderMethod(
              userName: userName,
              onPickUpTap: () {
                print("Action: Membuka Map Outlet untuk Pick Up");
                // Tambahkan navigasi ke halaman Pick Up di sini
              },
              onDeliveryTap: () {
                print("Action: Membuka Form Alamat untuk Delivery");
                // Tambahkan navigasi ke halaman Delivery di sini
              },
            ),

            const SizedBox(height: 25),

            // KOMPONEN RECOMMENDED (Grid Jamu)
            const HomeRecommended(),

            const SizedBox(height: 20), // Padding bawah extra
          ],
        ),
      ),
    );
  }
}
