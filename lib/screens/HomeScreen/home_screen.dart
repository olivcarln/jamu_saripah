import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Screens/HomeScreen/Components/menus.dart';
import 'package:jamu_saripah/screens/HomeScreen/Components/banner_promo.dart';
import 'Components/home_header.dart';
import 'Components/order_method.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

String userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Area (Background Banner + Welcome Text)
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
              child: const SafeArea(
                child: HomeHeader(),
              ),
            ),

            const SizedBox(height: 25),
            const PromoBanner(),
            const SizedBox(height: 25),

            OrderMethod(
              userName: userName,
              onPickUpTap: () {}, // Tambahin navigasi pick up lu di sini
              onDeliveryTap: () {}, // Tambahin navigasi delivery lu di sini
            ),

            const SizedBox(height: 25),
            const Menus(), // Komponen Grid Jamu
            const SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }
}