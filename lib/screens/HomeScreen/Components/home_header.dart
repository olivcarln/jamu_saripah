import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/screens/CartScreen/cart_screen.dart';
import 'package:jamu_saripah/screens/NotificationScreen/notification_screen.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  final Function(Map<String, String>) onFilterChanged;

  const HomeHeader({super.key, required this.onFilterChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String selectedPrice = "Harga Tertinggi";
  String selectedCategory = "250 ML";
  String selectedType = "Beras Kencur";

  Future<String> getCityName() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "GPS Mati";

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return "Izin Ditolak";
    }
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      return "${placemarks.first.subAdministrativeArea}, Indonesia";
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
                return Text(
                  snapshot.data ?? "Detecting...",
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(initialItems: []),
                ),
              ),
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
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFF7E8959)),
          onPressed: () => _showFilter(context),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  const Center(child: Text("Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  _buildExpandableSection(
                    title: "Harga",
                    groupValue: selectedPrice,
                    options: const ["Harga Tertinggi", "Harga Terendah"],
                    onChanged: (val) => setModalState(() => selectedPrice = val),
                  ),
                  _buildExpandableSection(
                    title: "Kategori",
                    groupValue: selectedCategory,
                    options: const ["250 ML", "350 ML", "1000 ML"],
                    onChanged: (val) => setModalState(() => selectedCategory = val),
                  ),
                  _buildExpandableSection(
                    title: "Jenis Jamu",
                    groupValue: selectedType,
                    options: const ["Beras Kencur", "Kunyit Asem", "Wedang Jahe"],
                    onChanged: (val) => setModalState(() => selectedType = val),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E8959),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      widget.onFilterChanged({
                        "harga": selectedPrice,
                        "kategori": selectedCategory,
                        "jenis": selectedType,
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpandableSection({required String title, required String groupValue, required List<String> options, required Function(String) onChanged}) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: groupValue,
          activeColor: const Color(0xFF7E8959),
          onChanged: (val) => onChanged(val!),
        );
      }).toList(),
    );
  }

 Widget _buildPointCard() {
  // PAKAI OrderProvider, bukan CartProvider lagi
  return Consumer<OrderProvider>(
    builder: (context, orderProvider, child) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 10, 
              offset: const Offset(0, 5)
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 10,
                  top: 15,
                  child: SvgPicture.asset(
                    'assets/coins.svg', 
                    width: 110,
                    placeholderBuilder: (context) => const SizedBox(width: 110, height: 110),
                  ),
                ),
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
                          width: 1.0
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.orange, size: 16),
                          const SizedBox(width: 6),
                          // AMBIL DARI orderProvider
                          Text(
                            "${orderProvider.userPoints} Points", 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 14, 
                              color: Colors.black87
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tukarkan poinmu dengan hadiah seru", 
                    style: TextStyle(fontSize: 12, color: Colors.black54)
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