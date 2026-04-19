import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  // Variabel untuk menyimpan filter yang dipilih
  String selectedFilter = "Bundle";

  // Fungsi pembantu untuk pindah halaman
  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER SECTION ---
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF7E8959),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () => _navigateTo(const PlaceholderScreen(title: "Cari Jamu")),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset('assets/pickup.png', height: 40, errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_shipping, color: Colors.white, size: 40)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Delivary",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF6B4226)),
                        ),
                        Text(
                          "Tinggal pesan, Kami yang antar",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _navigateTo(const PlaceholderScreen(title: "Pilih Lokasi Toko")),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.home, color: Color(0xFF7E8959)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Anggrek Cakra\n1.4 km ",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BODY SECTION ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Filter Horizontal
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterStar(),
                        const SizedBox(width: 8),
                        ...["Bundle", "250 ml", "350 ml", "1000 ml"].map((label) {
                          return _buildFilterChip(label);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orange, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Must Try!",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Grid Produk
                  Expanded(
                    child: GridView.builder(
                      itemCount: 4,
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        // Data variasi sesuai foto
                        List<String> titles = ["Wedang Jahe", "Beras Kencur", "Kunyit Asem", "Beras Kencur"];
                        List<Color> colors = [const Color(0xFF7E8959), const Color(0xFF8D6E4E)];
                        List<String> tags = ["Best Seller", "Top Order", "Most Populer", "Most Populer"];
                        List<IconData> icons = [Icons.sell, Icons.thumb_up, Icons.star, Icons.star];
                        List<Color> iconColors = [Colors.yellow.shade800, Colors.orange, Colors.orange, Colors.orange];

                        return _productCard(
                          title: titles[index],
                          tag: tags[index],
                          tagIcon: icons[index],
                          tagIconColor: iconColors[index],
                          bgColor: colors[index % 2],
                          imagePath: 'assets/jamu2.svg',
                          onPlusTap: () => _navigateTo(PlaceholderScreen(title: "Detail ${titles[index]}")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Filter Bintang
  Widget _buildFilterStar() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Icon(Icons.star_border, color: Colors.grey),
    );
  }

  // Widget Tombol Filter (Chip)
  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => setState(() => selectedFilter = label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF7E8959) : Colors.transparent,
          side: BorderSide(color: isSelected ? const Color(0xFF7E8959) : Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget Kartu Produk
  Widget _productCard({
    required String title,
    required String tag,
    required IconData tagIcon,
    required Color tagIconColor,
    required Color bgColor,
    required String imagePath,
    required VoidCallback onPlusTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Area Foto (Tanpa Klik)
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(imagePath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_drink, size: 50, color: Colors.white)),
                  ),
                ),
              ),
              // Tag (Sama seperti di foto)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(tagIcon, size: 12, color: tagIconColor),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text("Jamu", style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rp 11.776",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            // Tombol (+) Hanya bagian ini yang pindah ke detail
            GestureDetector(
              onTap: onPlusTap,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF7E8959),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Halaman Sementara (Ganti dengan halaman aslimu nanti)
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF7E8959)),
      body: Center(child: Text("Halaman $title")),
    );
  }
}