import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart';
import 'package:jamu_saripah/screens/HomeScreen/Components/banner_promo.dart';
import 'Components/home_header.dart';
import 'Components/order_method.dart'; 
import 'Components/home_recommended.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Naiput";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNav( 
        currentIndex: 0,
        onTap: (index) { },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
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
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),
                const HomeHeader(),
              ],
            ),
            const SizedBox(height: 25),
            const PromoBanner(),
            const SizedBox(height: 25),
            OrderMethod(
              userName: userName,
              onPickUpTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text("Pick Up")),
                      body: const Center(
                        child: Placeholder(
                          fallbackHeight: 250,
                          fallbackWidth: 250,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onDeliveryTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text("Delivery")),
                      body: const Center(
                        child: Placeholder(
                          fallbackHeight: 250,
                          fallbackWidth: 250,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            const HomeRecommended(),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}