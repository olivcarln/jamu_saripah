import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/Models/order.dart';
import 'package:jamu_saripah/common/constasts.dart'; // Memastikan AppColors terbaca
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
  int hargaTas = 3000;
  String selectedBooth = 'Plaza Atria Jakarta';

  List<String> booths = [
    'Plaza Atria Jakarta',
    'Gedung Jamsostek',
    'Lippo Mal Karawaci',
  ];

  Map<String, dynamic>? selectedPayment;
  Map<String, dynamic>? appliedVoucher;
  
  late List<Map<String, dynamic>> localCartItems = widget.cartItems.map((item) {
    return {
      'name': item.name,
      'price': item.price,
      'qty': item.quantity,
      'size': item.size,
      'image': item.image,
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    loadCompressedImages();
  }

  Future<void> loadCompressedImages() async {
    List<Map<String, dynamic>> tempItems = [];
    for (var item in widget.cartItems) {
      String compressedImage = item.image;
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
    if (mounted) {
      setState(() {
        localCartItems = tempItems;
      });
    }
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  int calculateSubtotal() {
    return localCartItems.fold(
      0,
      (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)),
    );
  }

  int calculateVoucherDiscount() {
    if (appliedVoucher == null) return 0;
    final subtotal = calculateSubtotal();
    final minPurchase = (appliedVoucher!['minPurchase'] ?? 0) as int;
    final discountPercent = (appliedVoucher!['discountPercent'] ?? 0) as int;

    if (subtotal < minPurchase) {
      return 0;
    }
    return ((subtotal * discountPercent) / 100).toInt();
  }

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
          onPressed: () => Navigator.pop(context),
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
                      onAddTap: (name, size, price, image) async {
                        String finalImage = image;

                        // Kompresi gambar menu tambahan jika dalam format Base64
                        if (image != null && !image.startsWith('assets')) {
                          finalImage = await compressBase64Image(image);
                        }

                        if (mounted) {
                          setState(() {
                            localCartItems.add({
                              'name': name,
                              'size': size,
                              'price': price,
                              'qty': 1,
                              'image': finalImage,
                            });

                            // Validasi ulang voucher jika diperlukan
                            if (appliedVoucher != null) {
                              final subtotal = calculateSubtotal();
                              final minPurchase = (appliedVoucher!['minPurchase'] ?? 0) as int;
                              if (subtotal < minPurchase) {
                                appliedVoucher = null;
                              }
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF7E8959),
                              content: Text("$name ($size) berhasil ditambahkan"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
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
                  _buildClickableSection(
                    title: appliedVoucher != null ? 'Voucher Dipakai' : 'Voucher Diskon',
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
                            subtotal: calculateSubtotal(),
                            selectedVouchers: appliedVoucher != null ? [appliedVoucher!] : [],
                          );
                        },
                      );

                      if (result != null && result is List) {
                        setState(() {
                          if (result.isNotEmpty) {
                            appliedVoucher = result.first;
                          } else {
                            appliedVoucher = null;
                          }
                        });
                        if (result.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF7E8959),
                              content: Text("${result.length} voucher berhasil digunakan"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(thickness: 1, color: Color(0xFFF1F1F1)),
                  _buildClickableSection(
                    title: 'Metode Pembayaran',
                    subtitle: selectedPayment != null ? selectedPayment!['name'] : 'Pilih pembayaranmu',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentScreen()),
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
          const Icon(Icons.person_pin_circle, color: Color(0xFF7E8959), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Pick Up',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7E8959), fontSize: 16),
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
                items: booths.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
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
          for (int i = 0; i < localCartItems.length; i++) 
            _buildDismissibleCartItem(localCartItems[i], i),
          const Divider(height: 30, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }

  Widget _buildDismissibleCartItem(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              "Hapus Menu?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text("Apakah kamu yakin ingin menghapus ${item['name']} dari detail pesanan?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: AppColors.brown, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        setState(() {
          localCartItems.removeAt(index);
          
          if (localCartItems.isEmpty || calculateSubtotal() < (appliedVoucher?['minPurchase'] ?? 0)) {
            appliedVoucher = null;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item['name']} berhasil dihapus"),
            backgroundColor: Colors.red.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: _buildCartItem(item),
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
                    ? Image.asset(item['image'], width: 60, height: 60, fit: BoxFit.cover)
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  item['size'] ?? '350 ml',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Qty: ${item['qty']}", style: const TextStyle(color: Colors.grey)),
                    Text(
                      "Rp ${formatHarga(item['price'])}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7E8959)),
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
                    child: const Icon(Icons.discount, color: Color(0xFF7E8959), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appliedVoucher!['code'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF7E8959)),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Voucher ${appliedVoucher!['discountPercent']}% berhasil dipakai",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "-Rp ${formatHarga(voucherDiscount)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              Text("Rp ${formatHarga(subtotal)}", style: const TextStyle(fontSize: 14)),
            ],
          ),
          if (perluTasBelanja) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tas Belanja", style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                Text("Rp ${formatHarga(hargaTas)}", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
          if (voucherDiscount > 0) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Diskon Voucher", style: TextStyle(fontSize: 14, color: Colors.green)),
                Text(
                  "-Rp ${formatHarga(voucherDiscount)}",
                  style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                "Rp ${formatHarga(calculateTotal())}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7E8959)),
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
          try {
            if (localCartItems.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Keranjang kamu kosong, yuk pilih jamu dulu"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            if (selectedPayment == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pilih metode pembayaran terlebih dahulu"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            BuildContext? dialogContext;
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (ctx) {
                dialogContext = ctx;
                return const Center(child: CircularProgressIndicator());
              },
            );

            final orderProvider = Provider.of<OrderProvider>(context, listen: false);
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            final user = FirebaseAuth.instance.currentUser;

            final List<Map<String, dynamic>> finalizedItems = [];
            for (var item in localCartItems) {
              finalizedItems.add({
                'name': (item['name'] ?? '').toString(),
                'price': (item['price'] ?? 0) as int,
                'qty': (item['qty'] ?? 1) as int,
                'size': (item['size'] ?? '350 ml').toString(),
                'image': (item['image'] ?? '').toString(),
              });
            }

            String autoDocId = FirebaseFirestore.instance.collection('orders').doc().id;

            final newOrder = OrderModel(
              id: autoDocId, 
              userEmail: user?.email ?? '',
              userId: user?.uid ?? '',
              userName: userProvider.name.isNotEmpty ? userProvider.name : "Customer",
              totalAmount: calculateTotal(),
              status: "Diproses",
              paymentMethod: selectedPayment!['name'],
              address: selectedBooth,
              createdAt: DateTime.now(), 
              items: finalizedItems, 
              image: finalizedItems.isNotEmpty ? finalizedItems.first['image'] ?? '' : '',
              paymentConfirmed: false,
            );

            await orderProvider.addOrder(newOrder);

            if (appliedVoucher != null && user != null) {
              String voucherDocId = (appliedVoucher!['id'] ?? appliedVoucher!['code'] ?? 'unknown_voucher').toString();

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('claimed_vouchers')
                  .doc(voucherDocId)
                  .set({
                    'voucherId': voucherDocId,
                    'usedAt': Timestamp.now(),
                  });

              await FirebaseFirestore.instance
                  .collection('global_vouchers')
                  .doc(voucherDocId)
                  .update({'quota': FieldValue.increment(-1)});
            }

            if (dialogContext != null) {
              Navigator.of(dialogContext!).pop();
            }

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pesanan berhasil dibuat"),
                  backgroundColor: Color(0xFF7E8959),
                ),
              );
            }

            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 1)),
                (route) => false,
              );
            }
          } catch (e) {
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal Simpan: $e"), backgroundColor: Colors.red),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7E8959),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          'Pesan Sekarang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<String> compressBase64Image(String base64String) async {
    try {
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }
      Uint8List imageBytes = base64Decode(cleanBase64);
      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: 40,
        minWidth: 600,
        minHeight: 600,
      );
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint("Compress image error: $e");
      return base64String;
    }
  }
}