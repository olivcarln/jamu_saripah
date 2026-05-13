import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/order_model.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
// import 'package:jamu_saripah/screens/CheckoutSreen/component/select_method_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
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
  int biayaLayanan = 2000;
  int diskonVoucher = 0;

  String selectedBooth = 'Plaza Atria Jakarta';

  List<String> booths = [
    'Plaza Atria Jakarta',
    'Gedung Jamsostek',
    'Lippo Mal Karawaci'
  ];

  Map<String, dynamic>? selectedPayment;
  Map<String, dynamic>? appliedVoucher;

  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();

    final cartProvider =
        Provider.of<CartProvider>(context, listen: false);

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

  int get subtotalProduk {
    return cartItems.fold(
      0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['qty'] as int)),
    );
  }

  int get totalTas => perluTasBelanja ? hargaTas : 0;

  int get totalKeseluruhan {
    int total = subtotalProduk +
        totalTas +
        biayaLayanan -
        diskonVoucher;

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
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text("Batalkan Pesanan?"),
                content: const Text(
                  "Data checkout mungkin tidak tersimpan.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Lanjut Checkout"),
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
              ),
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
                        : 'Yuk lebih hemat dengan voucher',
                    icon: Icons.confirmation_num_outlined,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VoucherScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          appliedVoucher = result;
                          diskonVoucher =
                              appliedVoucher!['discount'];
                        });
                      }
                    },
                  ),

                  const Divider(
                    thickness: 8,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildClickableSection(
                    title: 'Metode Pembayaran',
                    subtitle: selectedPayment != null
                        ? selectedPayment!['name']
                        : 'Pilih pembayaranmu',
                    icon:
                        Icons.account_balance_wallet_outlined,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentScreen(),
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

                  _buildRincianSection(),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildDeliveryMode() {
    return Container(
      color: const Color(0xFFF9FCF3),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            currentMethod == 'Delivery'
                ? Icons.local_shipping
                : Icons.store,
            color: const Color(0xFF7E8959),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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

          // OutlinedButton(
          //   onPressed: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) =>
          //             const SelectMethodScreen(),
          //       ),
          //     );

          //     if (result != null) {
          //       setState(() {
          //         currentMethod = result;
          //       });
          //     }
          //   },
          //   child: const Text("Ubah"),
          // ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    bool isDelivery = currentMethod == 'Delivery';

    if (isDelivery) {
      return const ListTile(
        leading: Icon(
          Icons.location_on_outlined,
          color: Color(0xFF7E8959),
        ),
        title: Text(
          'Rumah - Jatiasih',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Jl. Melati No.12, Bekasi'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selectedBooth,
        items: booths.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            selectedBooth = val!;
          });
        },
      ),
    );
  }

  Widget _buildDetailPesananSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Detail Pesanan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(height: 20),

          for (int i = 0; i < cartItems.length; i++)
            _buildCartItem(cartItems[i], i),

          OutlinedButton(
            onPressed: () {
              setState(() {
                showSpecialPackage =
                    !showSpecialPackage;
              });
            },
            child: const Text("Tambah Menu"),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      Map<String, dynamic> item,
      int index,
      ) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,

          title: Text(
            item['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(item['size']),

          trailing: Text(
            'Rp ${formatHarga(item['price'] * item['qty'])}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF7E8959),
            ),
          ),
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (item['qty'] > 1) {
                    item['qty']--;
                  } else {
                    cartItems.removeAt(index);
                  }
                });
              },
            ),

            Text('${item['qty']}'),

            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  item['qty']++;
                });
              },
            ),
          ],
        ),

        const Divider(),
      ],
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
      child: Column(
        children: [
          _rowHarga(
            'Subtotal Produk',
            subtotalProduk,
          ),

          if (totalTas > 0)
            _rowHarga(
              'Tas Belanja',
              totalTas,
            ),

          _rowHarga(
            'Biaya Layanan',
            biayaLayanan,
          ),

          if (diskonVoucher > 0)
            _rowHarga(
              'Diskon Voucher',
              -diskonVoucher,
            ),

          const Divider(),

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
      padding:
          const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label),

          Text(
            harga < 0
                ? '- Rp ${formatHarga(harga.abs())}'
                : 'Rp ${formatHarga(harga)}',
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
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content:
                    Text('Keranjang kosong'),
              ),
            );
            return;
          }

          if (selectedPayment == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Pilih metode pembayaran',
                ),
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
              items: cartItems,
            );

            await orderProvider.addOrder(order);

            cartProvider.clearCart();

            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Pesanan berhasil diproses!',
                ),
              ),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MainScreen(),
              ),
              (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content:
                    Text('Gagal memesan: $e'),
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