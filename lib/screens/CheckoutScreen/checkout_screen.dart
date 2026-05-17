import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String currentMethod = 'Pick Up';

  bool showSpecialPackage = true;

  bool perluTasBelanja = false;

  bool isPopping = false;

  int hargaTas = 3000;

  String selectedBooth = 'Plaza Atria Jakarta';

  List<String> booths = [
    'Plaza Atria Jakarta',
    'Gedung Jamsostek',
    'Lippo Mal Karawaci',
  ];

  Map<String, dynamic>? selectedPayment;

  /// VOUCHER
  Map<String, dynamic>? appliedVoucher;

  late List<Map<String, dynamic>> localCartItems;
  @override
  void initState() {
    super.initState();

    localCartItems = [];

    loadCompressedImages();
  }

  Future<void> loadCompressedImages() async {
    List<Map<String, dynamic>> tempItems = [];

    for (var item in widget.cartItems) {
      String compressedImage = item.image;

      /// JIKA BASE64
      if (!item.image.startsWith('assets')) {
        compressedImage = await compressBase64Image(item.image);
      }

      tempItems.add({
        'name': item.name,
        'price': item.price,
        'qty': item.quantity,
        'size': item.size,
        'image': compressedImage,
      });
    }

    setState(() {
      localCartItems = tempItems;
    });
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// SUBTOTAL
  int calculateSubtotal() {
    return localCartItems.fold(
      0,
      (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)),
    );
  }

  /// DISKON VOUCHER
  int calculateVoucherDiscount() {
    if (appliedVoucher == null) return 0;

    final subtotal = calculateSubtotal();

    final minPurchase = (appliedVoucher!['minPurchase'] ?? 0) as int;

    final discountPercent = (appliedVoucher!['discountPercent'] ?? 0) as int;

    /// BELUM MEMENUHI MINIMUM PEMBELIAN
    if (subtotal < minPurchase) {
      return 0;
    }

    return ((subtotal * discountPercent) / 100).toInt();
  }

  /// TOTAL AKHIR
  int calculateTotal() {
    int subtotal = calculateSubtotal();

    int total = perluTasBelanja ? subtotal + hargaTas : subtotal;

    total -= calculateVoucherDiscount();

    return total > 0 ? total : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
      leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
  onPressed: () {

    if (isPopping) return;

    isPopping = true;

    Navigator.pop(context);
  },
),

        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        backgroundColor: const Color(0xFF7E8959),

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

                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),

                  _buildDetailPesananSection(),

                  if (showSpecialPackage)
                    AddingMenuScreen(
                      onAddTap: (name, size, price, image) {
                        setState(() {
                          localCartItems.add({
                            'name': name,
                            'size': size,
                            'price': price,
                            'qty': 1,
                            'image': image,
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

                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),

                  /// VOUCHER
                  _buildClickableSection(
                    title: appliedVoucher != null
                        ? 'Voucher Dipakai'
                        : 'Voucher Diskon',

                    subtitle: appliedVoucher != null
                        ? '${appliedVoucher!['code']} • Diskon ${appliedVoucher!['discountPercent']}%'
                        : 'Yuk lebih hemat dengan voucher',

                    icon: Icons.confirmation_num_outlined,

                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,

                        builder: (context) {
                          return VoucherScreen(
                            selectedVoucher: appliedVoucher,

                            /// KIRIM SUBTOTAL
                            subtotal: calculateSubtotal(),

                            /// MULTIPLE VOUCHER
                            selectedVouchers: appliedVoucher != null
                                ? [appliedVoucher!]
                                : [],
                          );
                        },
                      );

                      if (result != null && result is List) {
                        setState(() {
                          /// AMBIL VOUCHER PERTAMA
                          if (result.isNotEmpty) {
                            appliedVoucher = result.first;
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF7E8959),

                            content: Text(
                              "${result.length} voucher berhasil digunakan",
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  const Divider(thickness: 1, color: Color(0xFFF1F1F1)),

                  /// PAYMENT
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
                          builder: (context) => const PaymentScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedPayment = result;
                        });
                      }
                    },
                  ),

                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [_buildRincianBayar(), _buildBottomBar()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMode() {
    return Container(
      color: const Color(0xFFF9FCF3),

      padding: const EdgeInsets.all(16),

      child: Row(
        children: [
          const Icon(
            Icons.person_pin_circle,
            color: Color(0xFF7E8959),
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: const [
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
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.grey.shade300),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBooth,

                isExpanded: true,

                items: booths
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),

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

  Widget _buildDetailPesananSection() {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Detail Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 20),

          for (var item in localCartItems) _buildCartItem(item),

          const Divider(height: 30, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),

            child: item['image'] != null
                ? item['image'].toString().startsWith('assets')
                      ? Image.asset(
                          item['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          base64Decode(item['image']),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  item['size'] ?? '350 ml',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "Qty: ${item['qty']}",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    Text(
                      "Rp ${formatHarga(item['price'])}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E8959),
                      ),
                    ),
                  ],
                ),
              ],
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
      leading: Icon(icon, color: const Color(0xFF7E8959)),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

      subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),

      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

      onTap: onTap,
    );
  }

  Widget _buildRincianBayar() {
    final subtotal = calculateSubtotal();

    final voucherDiscount = calculateVoucherDiscount();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// BOX VOUCHER
          if (appliedVoucher != null && voucherDiscount > 0) ...[
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: const Color(0xFFF5F9ED),

                borderRadius: BorderRadius.circular(14),

                border: Border.all(color: const Color(0xFFD8E5BE)),
              ),

              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F0D5),

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.discount,
                      color: Color(0xFF7E8959),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          appliedVoucher!['code'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF7E8959),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "Voucher ${appliedVoucher!['discountPercent']}% berhasil dipakai",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "-Rp ${formatHarga(voucherDiscount)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
          ],

          /// SUBTOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Subtotal",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),

              Text(
                "Rp ${formatHarga(subtotal)}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          /// TAS
          if (perluTasBelanja) ...[
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "Tas Belanja",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),

                Text(
                  "Rp ${formatHarga(hargaTas)}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],

          /// DISKON
          if (voucherDiscount > 0) ...[
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Diskon Voucher",
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),

                Text(
                  "-Rp ${formatHarga(voucherDiscount)}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),

            child: Divider(height: 1),
          ),

          /// TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Text(
                "Rp ${formatHarga(calculateTotal())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7E8959),
                ),
              ),
            ],
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

  /// CEGAH DOUBLE CLICK / DATA BELUM SIAP
  if (localCartItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data produk belum siap"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {

    /// VALIDASI PAYMENT
    if (selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih metode pembayaran terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    /// LOADING
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final orderProvider = Provider.of<OrderProvider>(
      context,
      listen: false,
    );

    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    final user = FirebaseAuth.instance.currentUser;

    /// ORDER
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),

      /// USER
      userEmail: user?.email ?? '',
      userId: user?.uid ?? '',
      userName: userProvider.name.isNotEmpty
          ? userProvider.name
          : "Customer",

      /// TOTAL
      totalAmount: calculateTotal(),

      /// STATUS
      status: "Diproses",

      /// PAYMENT
      paymentMethod: selectedPayment!['name'],

      /// OUTLET
      address: selectedBooth,

      /// DATE
      createdAt: DateTime.now(),

      /// ITEMS
      items: localCartItems.map((item) {
        return {
          'name': item['name'] ?? '',
          'price': item['price'] ?? 0,
          'qty': item['qty'] ?? 1,
          'size': item['size'] ?? '',
          'image': item['image'] ?? '',
        };
      }).toList(),

      /// THUMBNAIL
      image: localCartItems.isNotEmpty
          ? localCartItems.first['image'] ?? ''
          : '',

      /// PAYMENT STATUS
      paymentConfirmed: false,
    );

    /// SIMPAN ORDER
    await orderProvider.addOrder(newOrder);

    /// SIMPAN VOUCHER
    if (appliedVoucher != null && user != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('claimed_vouchers')
          .doc(appliedVoucher!['id'])
          .set({
        'voucherId': appliedVoucher!['id'],
        'usedAt': Timestamp.now(),
      });

      /// KURANGI QUOTA
      await FirebaseFirestore.instance
          .collection('global_vouchers')
          .doc(appliedVoucher!['id'])
          .update({
        'quota': FieldValue.increment(-1),
      });
    }

    /// TUTUP LOADING
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    /// SUCCESS
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pesanan berhasil dibuat"),
          backgroundColor: Color(0xFF7E8959),
        ),
      );
    }

    /// PINDAH KE HISTORY
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MainScreen(initialIndex: 1),
        ),
        (route) => false,
      );
    }

  } catch (e) {

    /// TUTUP LOADING
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Gagal: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
},

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7E8959),

          minimumSize: const Size(double.infinity, 54),

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

  /// COMPRESS BASE64 IMAGE
  Future<String> compressBase64Image(String base64String) async {
    try {
      /// HAPUS PREFIX DATA IMAGE JIKA ADA
      String cleanBase64 = base64String;

      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }

      /// BASE64 -> UINT8LIST
      Uint8List imageBytes = base64Decode(cleanBase64);

      /// COMPRESS IMAGE
      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: 40, // semakin kecil semakin hemat
        minWidth: 600,
        minHeight: 600,
      );

      /// UINT8LIST -> BASE64
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint("Compress image error: $e");

      return base64String;
    }
  }
}
