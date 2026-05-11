import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/screens/CartScreen/cart_screen.dart';
import 'package:jamu_saripah/screens/NotificationScreen/notification_screen.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String selectedPrice = "Harga Tertinggi";
  String selectedCategory = "250 ML";
  String selectedType = "Beras Kencur";

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
            _buildSearchBar(context),
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

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari Jamu Favoritmu...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => _showFilter(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryOlive.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.tune, size: 20, color: AppColors.primaryOlive),
            ),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Center(
                    child: Text(
                      "Filter",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildExpandableSection(
                    title: "Harga",
                    groupValue: selectedPrice,
                    options: const ["Harga Tertinggi", "Harga Terendah"],
                    onChanged: (val) =>
                        setModalState(() => selectedPrice = val),
                  ),

                  _buildExpandableSection(
                    title: "Kategori",
                    groupValue: selectedCategory,
                    options: const ["250 ML", "350 ML", "1000 ML"],
                    onChanged: (val) =>
                        setModalState(() => selectedCategory = val),
                  ),

                  _buildExpandableSection(
                    title: "Jenis Jamu",
                    groupValue: selectedType,
                    options: const [
                      "Beras Kencur",
                      "Kunyit Asem",
                      "Wedang Jahe"
                    ],
                    onChanged: (val) =>
                        setModalState(() => selectedType = val),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOlive,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filter",
                        style: TextStyle(fontSize: 16, color: AppColors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String groupValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        iconColor: AppColors.primaryOlive,
        collapsedIconColor: Colors.black54,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: options.map((option) {
          return RadioListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primaryOlive,
            title: Text(option),
            value: options,
            groupValue: groupValue,
            onChanged: (value) => onChanged(value as String),
          );
        }).toList(),
      ),
    );
  }

Widget _buildPointCard() {
  return Consumer<CartProvider>(
    builder: (context, cart, child) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- BAGIAN ATAS: Pill Poin & Background Koin ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Gambar Koin Background
                Positioned(
                  right: 10,
                  top: 15,
                  child: SvgPicture.asset(
                    'assets/coins.svg',
                    width: 110, // Ukuran koin background disesuaikan
                  ),
                ),
                
                // Pil Angka Poin (Sudah diperkecil)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E9D2).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF8D6E63).withOpacity(0.8), 
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.orange, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "${cart.totalPoints} Points",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Ukuran teks poin lebih kecil
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- GARIS PEMISAH ---
            Divider(height: 1, color: Colors.grey.withOpacity(0.1)),

            // --- BAGIAN BAWAH: Teks Keterangan ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Redeem your points for exciting rewards",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
}