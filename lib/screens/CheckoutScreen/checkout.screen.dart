import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/Models/order.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/provider/user_provider.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:provider/provider.dart';


class CheckoutScreen extends StatefulWidget {

  final List<CartItem> cartItems;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String currentMethod = 'Pick Up';

  bool showSpecialPackage = true;
  bool perluTasBelanja = false;

  int hargaTas = 3000;

  String selectedBooth = 'Plaza Atria Jakarta';

  List<String> booths = [
    'Plaza Atria Jakarta',
    'Gedung Jamsostek',
    'Lippo Mal Karawaci',
  ];

  Map<String, dynamic>? selectedPayment;
  Map<String, dynamic>? appliedVoucher;

  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();

    cartItems = [
      {
        'name': 'Jamu Beras Kencur',
        'size': '350 ml',
        'price': widget.cartItems.isNotEmpty ? widget.cartItems.first.price : 19500,
        'qty': 1,
        'image': 'assets/images/beras_kencur.png',
      },
    ];
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  int calculateTotal() {
    int totalProduk = cartItems.fold(
      0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['qty'] as int)),
    );

    int total = perluTasBelanja
        ? totalProduk + hargaTas
        : totalProduk;

    if (appliedVoucher != null) {
      total -= (appliedVoucher!['discount'] as int);
    }

    return total > 0 ? total : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF7E8959),
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDeliveryMode(),

                  _buildLocationInfo(),

                  const Divider(
                    thickness: 8,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildDetailPesananSection(),

          if (showSpecialPackage)
  AddingMenuScreen(
    onAddTap: (
      String? n,
      String? s,
      int? p,
      String? img,
    ) {
      setState(() {
        cartItems.add({
          'name': n ?? 'Menu Spesial',
          'size': s ?? '',
          'price': p ?? 0,
          'qty': 1,
          'image': img ?? '',
        });
      });
    },
  ),

                  ShoppingBagScreen(
                    isSelected: perluTasBelanja,
                    harga: hargaTas,
                    onChanged: (val) {
                      setState(() {
                        perluTasBelanja = val;
                      });
                    },
                  ),

                  const Divider(
                    thickness: 8,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildClickableSection(
                    title: appliedVoucher != null
                        ? 'Voucher Dipakai'
                        : 'Voucher Diskon',

                    subtitle: appliedVoucher != null
                        ? 'Potongan Rp ${formatHarga(appliedVoucher!['discount'])}'
                        : 'yuk lebih hemat dengan voucher',

                    icon: Icons.confirmation_num_outlined,

                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const VoucherScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          appliedVoucher = result;
                        });
                      }
                    },
                  ),

                  const Divider(
                    thickness: 1,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildClickableSection(
                    title: 'Metode Pembayaran',

                    subtitle: selectedPayment != null
                        ? selectedPayment!['name']
                        : 'Pilih pembayaranmu',

                    icon: Icons.account_balance_wallet_outlined,

                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaymentScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedPayment = result;
                        });
                      }
                    },
                  ),

                  const Divider(
                    thickness: 8,
                    color: Color(0xFFF1F1F1),
                  ),
                ],
              ),
            ),
          ),

          const Divider(
            height: 1,
            color: Color(0xFFF1F1F1),
          ),

          _buildRincianSection(),
        ],
      ),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildDetailPesananSection() {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Detail Pesanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          for (int i = 0; i < cartItems.length; i++)
            _buildCartItem(cartItems[i], i),

          const Divider(
            height: 30,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    Map<String, dynamic> item,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildProductImage(item['image'] ?? ''),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item['name'] ?? 'No Name',

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item['size'] ?? '',

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Qty: ${item['qty']}",

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Rp ${formatHarga(item['price'] ?? 0)}",

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E8959),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE BUILDER
  Widget _buildProductImage(String imageSource) {
    if (imageSource.isEmpty) {
      return _errorImage();
    }

    /// BASE64
    if (imageSource.length > 100 &&
        !imageSource.startsWith('http')) {
      try {
        return Image.memory(
          base64Decode(imageSource),

          width: 80,
          height: 80,

          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) {
            return _errorImage();
          },
        );
      } catch (e) {
        return _errorImage();
      }
    }

    /// NETWORK
    if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,

        width: 80,
        height: 80,

        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return _errorImage();
        },
      );
    }

    /// SVG
    if (imageSource.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imageSource,

        width: 80,
        height: 80,

        fit: BoxFit.cover,
      );
    }

    /// ASSET
    return Image.asset(
      imageSource,

      width: 80,
      height: 80,

      fit: BoxFit.cover,

      errorBuilder: (context, error, stackTrace) {
        return _errorImage();
      },
    );
  }

  Widget _errorImage() {
    return Container(
      width: 80,
      height: 80,

      color: Colors.grey.shade200,

      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDeliveryMode() {
    return Container(
      color: const Color(0xFFF9FCF3),

      padding: const EdgeInsets.all(16),

      child: const Row(
        children: [
          Icon(
            Icons.person_pin_circle,
            color: Color(0xFF7E8959),
            size: 24,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Pick Up',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E8959),
                    fontSize: 16,
                  ),
                ),

                Text(
                  'Datang, ambil, beres!',

                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Pesananmu siap diambil di sini",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBooth,

                isExpanded: true,

                items: booths.map((val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),

                onChanged: (nv) {
                  setState(() {
                    selectedBooth = nv!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF7E8959),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Text(subtitle),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

      onTap: onTap,
    );
  }

  Widget _buildRincianSection() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const Text(
            'Total Pembayaran',

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            'Rp ${formatHarga(calculateTotal())}',

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF7E8959),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: ElevatedButton(
        onPressed: () async {
          if (cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Keranjang kosong'),
              ),
            );

            return;
          }

          if (selectedPayment == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pilih metode pembayaran'),
              ),
            );

            return;
          }

          try {
            final orderProvider =
                Provider.of<OrderProvider>(
              context,
              listen: false,
            );

            final userProvider =
                Provider.of<UserProvider>(
              context,
              listen: false,
            );

            await orderProvider.addOrder(
              OrderModel(
                id: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(),

                userName: userProvider.name,

                totalAmount: calculateTotal(),

                status: "Menunggu",

                paymentMethod:
                    selectedPayment!['name'],

                address: selectedBooth,

                createdAt: DateTime.now(),

                items: List.from(cartItems),

                image: cartItems.first['image'],

                paymentConfirmed: false,
              ),
            );

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Pesanan berhasil dibuat',
                  ),
                ),
              );
            }

            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const MainScreen(),
                ),

                (route) => false,
              );
            }
          } catch (e) {
            debugPrint("Error checkout: $e");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Terjadi kesalahan: $e',
                ),
              ),
            );
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7E8959),

          minimumSize: const Size(
            double.infinity,
            54,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),

        child: const Text(
          'Pesan Sekarang',

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}