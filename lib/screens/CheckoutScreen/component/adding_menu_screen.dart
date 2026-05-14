import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddingMenuScreen extends StatelessWidget {
   final Function(
    String?,
    String?,
    int?,
    String?,
  ) onAddTap;

  const AddingMenuScreen({super.key, required this.onAddTap});

  final List<Map<String, dynamic>> specialMenus = const [
    {'name': '3 Botol Beras kencur', 'size': '350 ml', 'price': 58000, 'image': 'assets/product_2.svg'},
    {'name': 'Paket Mix 5 Jamu', 'size': '350 ml', 'price': 96500, 'image': 'assets/product_2.svg'},
    {'name': 'Kunyit Asem ', 'size': '250 ml', 'price': 13500, 'image': 'assets/product_2.svg'},
  ];

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text.rich(
            TextSpan(
              text: 'Paket ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              children: [
                TextSpan(text: 'SpecialJAMU', style: TextStyle(color: Color(0xFF7E8959))),
                TextSpan(text: ' hari ini!'),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: specialMenus.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final menu = specialMenus[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF7E8959).withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: _buildProductImage(menu['image']),
),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(menu['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(menu['size'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp ${formatHarga(menu['price'])}', // Panggil fungsi format di sini
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D8C3F),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => onAddTap(
                                  menu['name'],
                                  menu['size'],
                                  menu['price'],
                                  menu['image'],
                                ),
                                child: const Icon(Icons.add_circle, color: Color(0xFF7E8959), size: 26),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

 Widget _buildProductImage(String imageSource) {

  debugPrint("IMAGE SOURCE => $imageSource");

  // KALAU KOSONG
  if (imageSource.isEmpty) {
    return _errorImage();
  }

  /// =========================
  /// NETWORK IMAGE
  /// =========================
  if (imageSource.startsWith('http')) {
    return Image.network(
      imageSource,
      width: 60,
      height: 60,
      fit: BoxFit.cover,

      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;

        return Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },

      errorBuilder: (context, error, stackTrace) {
        debugPrint("NETWORK IMAGE ERROR => $error");
        return _errorImage();
      },
    );
  }

  /// =========================
  /// SVG ASSET
  /// =========================
  if (imageSource.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(
      imageSource,
      width: 60,
      height: 60,
      fit: BoxFit.cover,

      placeholderBuilder: (context) {
        return Container(
          width: 60,
          height: 60,
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
    );
  }

  /// =========================
  /// PNG / JPG ASSET
  /// =========================
  return Image.asset(
    imageSource,
    width: 60,
    height: 60,
    fit: BoxFit.cover,

    errorBuilder: (context, error, stackTrace) {
      debugPrint("ASSET IMAGE ERROR => $error");
      return _errorImage();
    },
  );
}

/// =========================
/// ERROR IMAGE
/// =========================
Widget _errorImage() {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(
      Icons.broken_image,
      color: Colors.grey,
    ),
  );
}
}