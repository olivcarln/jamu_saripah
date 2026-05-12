import 'package:flutter/material.dart';
import 'Components/filter_sheet.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 1. DATA PRODUK ASLI (Sesuai gambar kamu)
  final List<Map<String, dynamic>> _allProducts = [
    {"name": "Wedang Jahe", "price": 12000, "category": "250 ML", "type": "Wedang Jahe", "image": "assets/wedang_jahe.png"},
    {"name": "Beras Kencur", "price": 22000, "category": "350 ML", "type": "Beras Kencur", "image": "assets/beras_kencur.png"},
    {"name": "Kunyit Asam", "price": 11000, "category": "250 ML", "type": "Kunyit Asem", "image": "assets/kunyit_asam.png"},
  ];

  // 2. LIST UNTUK DITAMPILKAN (Hasil Filter)
  List<Map<String, dynamic>> _displayedProducts = [];
  Map<String, String> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _displayedProducts = List.from(_allProducts); // Awalnya muncul semua
  }

  // 3. FUNGSI LOGIKA FILTER & SORTING
  void _applyLogicFilter(Map<String, String> filters) {
    setState(() {
      _activeFilters = filters;
      List<Map<String, dynamic>> tempProducts = List.from(_allProducts);

      // Filter Kategori (ML)
      if (filters['kategori'] != null && filters['kategori']!.isNotEmpty) {
        tempProducts = tempProducts.where((p) => p['category'] == filters['kategori']).toList();
      }

      // Filter Jenis Jamu
      if (filters['jenis'] != null && filters['jenis']!.isNotEmpty) {
        tempProducts = tempProducts.where((p) => p['type'] == filters['jenis']).toList();
      }

      // SORTING HARGA (Ini yang kamu minta)
      if (filters['harga'] == "Harga Terendah") {
        tempProducts.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (filters['harga'] == "Harga Tertinggi") {
        tempProducts.sort((a, b) => b['price'].compareTo(a['price']));
      }

      _displayedProducts = tempProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jamu Saripah"),
        backgroundColor: const Color(0xFF7E8959),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _openFilter(context),
          )
        ],
      ),
      body: _displayedProducts.isEmpty
          ? const Center(child: Text("Produk tidak ditemukan"))
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _displayedProducts.length,
              itemBuilder: (context, index) {
                final product = _displayedProducts[index];
                return _buildProductCard(product);
              },
            ),
    );
  }

  // UI CARD PRODUK (Sesuai gambar kamu)
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.grey)), // Ganti Image.asset nanti
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Rp ${product['price']}", style: const TextStyle(color: Color(0xFF7E8959), fontWeight: FontWeight.bold)),
                Text(product['category'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterSheet(
        onApply: (selectedData) => _applyLogicFilter(selectedData),
      ),
    );
  }
}