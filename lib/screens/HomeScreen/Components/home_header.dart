import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/screens/CartScreen/cart_screen.dart';
import 'package:jamu_saripah/screens/NotificationScreen/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<String> getCityName() async {
    // cek permission dulu
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return "Location denied";
    }

    // ambil posisi
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // convert ke alamat
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    return "${place.locality ?? "Unknown"}, ${place.country ?? ""}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 30),
            _buildPointCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Location",
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),

            // 🔥 INI YANG REAL-TIME LOCATION
            FutureBuilder<String>(
              future: getCityName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Detecting location...",
                    style: TextStyle(color: Colors.white),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                    "Location error",
                    style: TextStyle(color: Colors.white),
                  );
                }

                return Text(
                  snapshot.data ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),

        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreen(
                      initialItems: [
                        CartItem(
                          name: "Beras Kencur Premium",
                          size: "350 ml",
                          price: 56000,
                          image: "assets/jamu-1.png",
                          isChecked: true,
                          quantity: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPointCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: SvgPicture.asset(
              'assets/coins.svg',
              width: 120,
              placeholderBuilder: (context) =>
                  const SizedBox(width: 120, height: 50),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF5E6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.monetization_on,
                      color: Color(0xFFD4AF37),
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "100 Points",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Text(
                    "Redeem your points for exciting rewards",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 12, color: Colors.black54),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}