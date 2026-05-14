import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Screens/HomeScreen/Components/menus.dart';
import 'package:jamu_saripah/screens/HomeScreen/Components/banner_promo.dart';

import 'Components/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName =
      FirebaseAuth.instance.currentUser?.displayName ?? "User";

  bool isLoading = false;

  Map<String, String> _activeFilters = {};

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
                // HEADER
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
                  child: SafeArea(
                    child: HomeHeader(
                      onFilterChanged: (filters) {
                        setState(() {
                          _activeFilters = filters;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PROMO
                const PromoBanner(),

                const SizedBox(height: 25),

                // MENUS
                const Menus(),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // LOADING
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7E8959),
                ),
              ),
            ),
        ],
      ),
    );
  }
}