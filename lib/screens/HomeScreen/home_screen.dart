import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/DeliveryScreen/delivery_screen.dart';
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
                  builder: (context) => PickupScreen(),
                 )
                );
              },
              onDeliveryTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickupScreen(),
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