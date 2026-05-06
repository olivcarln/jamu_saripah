import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jamu_saripah/screens/CartScreen/cart_screen.dart';
import 'package:jamu_saripah/screens/NotificationScreen/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Future<String> getCityName() async {
    // Pastikan service GPS menyala
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "GPS Mati";
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return "Izin Ditolak";
    }
    
    if (permission == LocationPermission.deniedForever) {
      return "Location denied";
    }

    // Ambil posisi presisi tinggi detik ini
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, // Pakai 'best' untuk akurasi maksimal
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      // Di Indonesia: subAdministrativeArea biasanya berisi "Kota Bekasi" atau "Kabupaten Bekasi"
      String city = place.subAdministrativeArea ?? place.locality ?? "Unknown";
      return "$city, Indonesia";
    }
    
    return "Unknown";
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
            const Text("Location", style: TextStyle(color: Colors.white70, fontSize: 10)),
            FutureBuilder<String>(
              future: getCityName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Detecting location...", style: TextStyle(color: Colors.white));
                }
                return Text(
                  snapshot.data ?? "Unknown",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                // ✅ Navigasi diperbaiki menjadi satu route saja
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CartScreen(initialItems: []))
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
        hintText: "Cari Jamu Favoritmu...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPointCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10, top: -10,
            child: SvgPicture.asset('assets/coins.svg', width: 120),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("100 Points", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 12),
              Divider(height: 1, color: Colors.black12),
              SizedBox(height: 12),
              Text("Redeem your points for exciting rewards", style: TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}