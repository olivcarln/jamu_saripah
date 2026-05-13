import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/order_model.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/select_method_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final int? totalPrice;
  final int? selectedCount;

  const CheckoutScreen({
    super.key,
    this.totalPrice,
    this.selectedCount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String currentMethod = 'Delivery';

  bool showSpecialPackage = false;
  bool perluTasBelanja = false;

  int hargaTas = 3000;
  int ongkir = 10000;
  int biayaLayanan = 2000;
  int diskonVoucher = 0;

  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();

    final CartProvider cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );

    cartItems = List<Map<String, dynamic>>.from(
      cartProvider.cartItems,
    );
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// =========================
  /// PERHITUNGAN HARGA
  /// =========================

  int get subtotalProduk {
    return cartItems.fold(
      0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['qty'] as int)),
    );
  }

  int get totalTas {
    return perluTasBelanja ? hargaTas : 0;
  }

 

  int get totalKeseluruhan {
    return subtotalProduk +
        totalTas +
        biayaLayanan -
        diskonVoucher;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// =========================
      /// APPBAR
      /// =========================
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF7E8959),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text("Batalkan Pesanan?"),
                  content: const Text(
                    "Data yang kamu isi mungkin tidak akan tersimpan.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Lanjut Checkout",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Ya, Batal",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
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

      /// =========================
      /// BODY
      /// =========================
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDeliveryMode(),

            _buildLocationInfo(),

            const Divider(
              thickness: 8,
              color: Color(0xFFF1F1F1),
            ),

            /// =========================
            /// DETAIL PESANAN
            /// =========================
            Padding(
              padding: const EdgeInsets.all(16),
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

                  const SizedBox(height: 10),

                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Belum ada pesanan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...cartItems.map(
                      (item) => _buildCartItem(item),
                    ),

                  const Divider(),

                  _buildAddMoreButton(),
                ],
              ),
            ),

            if (showSpecialPackage)
              AddingMenuScreen(
                onAddTap: (n, s, p) {
                  setState(() {
                    cartItems.add({
                      'name': n,
                      'size': s,
                      'price': p,
                      'qty': 1,
                      'image': '',
                    });
                  });
                },
              ),

            /// =========================
            /// TAS BELANJA
            /// =========================
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

            /// =========================
            /// VOUCHER
            /// =========================
            _buildClickableSection(
              title: 'Voucher Diskon',
              subtitle: diskonVoucher > 0
                  ? 'Diskon Rp ${formatHarga(diskonVoucher)}'
                  : 'Yuk lebih hemat dengan voucher',
              icon: Icons.confirmation_num_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const VoucherScreen(),
                  ),
                );
              },
            ),

            const Divider(
              thickness: 8,
              color: Color(0xFFF1F1F1),
            ),

            /// =========================
            /// METODE PEMBAYARAN
            /// =========================
            _buildClickableSection(
              title: 'Metode Pembayaran',
              subtitle: 'QRIS',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const PaymentScreen(),
                  ),
                );
              },
            ),

            const Divider(
              thickness: 8,
              color: Color(0xFFF1F1F1),
            ),

            /// =========================
            /// RINCIAN
            /// =========================
            _buildRincianSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),

      /// =========================
      /// BOTTOM BAR
      /// =========================
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// =========================
  /// DELIVERY MODE
  /// =========================
  Widget _buildDeliveryMode() {
    return Container(
      color: const Color(0xFFF9FCF3),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              currentMethod == 'Delivery'
                  ? Icons.local_shipping
                  : Icons.person_pin_circle,
              color: const Color(0xFF7E8959),
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E8959),
                    fontSize: 16,
                  ),
                ),

                Text(
                  currentMethod == 'Delivery'
                      ? 'Tinggal pesan, kami yang antar'
                      : 'Datang, ambil, beres!',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SelectMethodScreen(),
                  ),
                );

                if (result != null && result is String) {
                  setState(() {
                    currentMethod = result;
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Ubah',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    bool isDelivery = currentMethod == 'Delivery';

    return ListTile(
      leading: Icon(
        isDelivery
            ? Icons.location_on_outlined
            : Icons.store_outlined,
        color: const Color(0xFF7E8959),
      ),
      title: Text(
        isDelivery
            ? 'Rumah - Jatiasih'
            : 'Jamu Saripah - Anggrek Cakra',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        isDelivery
            ? 'Jl. Melati No. 12, Bekasi'
            : '1.4 km dari lokasimu',
      ),
    );
  }

  /// =========================
  /// CLICKABLE SECTION
  /// =========================
  Widget _buildClickableSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF7E8959),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
    );
  }

  /// =========================
  /// RINCIAN PEMBAYARAN
  /// =========================
  Widget _buildRincianSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          _rowHarga('Subtotal Produk', subtotalProduk),

          if (totalTas > 0)
            _rowHarga('Tas Belanja', totalTas),

    

          _rowHarga('Biaya Layanan', biayaLayanan),

          if (diskonVoucher > 0)
            _rowHarga(
              'Diskon Voucher',
              -diskonVoucher,
            ),

          const Divider(height: 30),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Text(
                'Rp ${formatHarga(totalKeseluruhan)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF7E8959),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowHarga(String label, int harga) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            harga < 0
                ? '- Rp ${formatHarga(harga.abs())}'
                : 'Rp ${formatHarga(harga)}',
            style: TextStyle(
              color:
                  harga < 0 ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// ADD MORE BUTTON
  /// =========================
  Widget _buildAddMoreButton() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Ada tambahan lagi?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        OutlinedButton(
          onPressed: () {
            setState(() {
              showSpecialPackage =
                  !showSpecialPackage;
            });
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0xFF7E8959),
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Tambah',
            style: TextStyle(
              color: Color(0xFF7E8959),
            ),
          ),
        ),
      ],
    );
  }

  /// =========================
  /// ITEM CART
  /// =========================
  Widget _buildCartItem(
    Map<String, dynamic> item,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      title: Text(
        item['name'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Text(
        '${item['size']} x${item['qty']}',
      ),

      trailing: Text(
        'Rp ${formatHarga((item['price'] as int) * (item['qty'] as int))}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF7E8959),
        ),
      ),
    );
  }

  /// =========================
  /// BOTTOM BAR
  /// =========================
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),

      child: ElevatedButton(
        onPressed: () async {
          try {
            final orderProvider =
                Provider.of<OrderProvider>(
              context,
              listen: false,
            );

            final cartProvider =
                Provider.of<CartProvider>(
              context,
              listen: false,
            );

            final order = OrderModel(
              id: DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),

              userName:
                  FirebaseAuth.instance.currentUser
                          ?.displayName ??
                      'Customer',

              totalAmount: totalKeseluruhan,

              status: 'Diproses',

              method: currentMethod,

              createdAt: DateTime.now(),

              items: cartItems
                  .map<Map<String, dynamic>>(
                (item) {
                  return {
                    'name': item['name'],
                    'image': item['image'] ?? '',
                    'qty': item['qty'],
                    'price': item['price'],
                  };
                },
              ).toList(),
            );

            /// SIMPAN ORDER
            await orderProvider.addOrder(order);

            /// CLEAR CART
            cartProvider.clearCart();

            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  "Pesanan berhasil diproses!",
                ),
              ),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MainScreen(),
              ),
              (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  "Gagal memesan: $e",
                ),
              ),
            );
          }
        },

        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF7E8959),
          minimumSize:
              const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30),
          ),
        ),

        child: Text(
          'Pesan Sekarang • Rp ${formatHarga(totalKeseluruhan)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}