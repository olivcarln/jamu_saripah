import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Screens/HomeScreen/Components/menus.dart';
import 'package:jamu_saripah/screens/HomeScreen/Components/banner_promo.dart';
import 'package:jamu_saripah/services/database_services.dart';
import 'Components/home_header.dart';
import 'Components/order_method.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";
  bool isLoading = false;

  // Fungsi pembantu untuk memproses klik pesanan
  void _prosesCheckout(String metode) async {
    setState(() => isLoading = true);

    try {
      // Data inilah yang akan dikirim ke Admin
      List<Map<String, dynamic>> jamuDipesan = [
        {'nama': 'Kunyit Asam', 'jumlah': 1, 'harga': 15000},
      ];

      // PERBAIKAN DI SINI: Gunakan named parameters sesuai DatabaseService
      await DatabaseService().buatPesanan(
        items: jamuDipesan, 
        total: 15000,      
        method: metode,     
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil memesan via $metode!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memesan: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Area
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const SafeArea(child: HomeHeader()),
                ),

                const SizedBox(height: 25),
                const PromoBanner(),
                const SizedBox(height: 25),

                // Order Method Section
                OrderMethod(
                  userName: userName,
                  onPickUpTap: () => _prosesCheckout("Pick Up"),
                  onDeliveryTap: () => _prosesCheckout("Delivery"),
                ),

                const SizedBox(height: 25),
                const Menus(), 
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF7E8959)),
              ),
            ),
        ],
      ),
    );
  }
}