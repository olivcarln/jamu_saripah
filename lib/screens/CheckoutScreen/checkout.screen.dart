import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/Models/order.dart';
import 'package:jamu_saripah/Screens/CheckoutScreen/component/select_method_screen.dart';
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
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {
  String currentMethod = 'Pick Up';

  bool showSpecialPackage = true;

  bool perluTasBelanja = false;

  int hargaTas = 3000;

  String selectedBooth =
      'Plaza Atria Jakarta';

  List<String> booths = [
    'Plaza Atria Jakarta',
    'Gedung Jamsostek',
    'Lippo Mal Karawaci',
  ];

  Map<String, dynamic>? selectedPayment;

  Map<String, dynamic>? appliedVoucher;

  late List<Map<String, dynamic>>
      localCartItems;

  @override
  void initState() {
    super.initState();

    localCartItems = widget.cartItems
        .map(
          (item) => {
            'name': item.name,
            'size': item.size,
            'price': item.price,
            'qty': item.quantity,
            'image': item.image,
          },
        )
        .toList();
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
          RegExp(
            r'(\d{1,3})(?=(\d{3})+(?!\d))',
          ),
          (Match m) => '${m[1]}.',
        );
  }

  int calculateTotal() {
    int totalProduk = localCartItems.fold(
      0,
      (sum, item) =>
          sum +
          ((item['price'] as int) *
              (item['qty'] as int)),
    );

    int total = perluTasBelanja
        ? totalProduk + hargaTas
        : totalProduk;

    if (appliedVoucher != null) {
      total -=
          (appliedVoucher!['discount']
              as int);
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
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        backgroundColor:
            const Color(0xFF7E8959),

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
                        name,
                        size,
                        price,
                        image,
                      ) {
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
                    isSelected:
                        perluTasBelanja,

                    harga: hargaTas,

                    onChanged: (val) {
                      setState(() {
                        perluTasBelanja =
                            val;
                      });
                    },
                  ),

                  const Divider(
                    thickness: 8,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildClickableSection(
                    title: appliedVoucher !=
                            null
                        ? 'Voucher Dipakai'
                        : 'Voucher Diskon',

                    subtitle:
                        appliedVoucher !=
                                null
                            ? 'Potongan Rp ${formatHarga(appliedVoucher!['discount'])}'
                            : 'Yuk lebih hemat dengan voucher',

                    icon: Icons
                        .confirmation_num_outlined,

                    onTap: () async {
                      final result =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) =>
                              const VoucherScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          appliedVoucher =
                              result;
                        });
                      }
                    },
                  ),

                  const Divider(
                    thickness: 1,
                    color: Color(0xFFF1F1F1),
                  ),

                  _buildClickableSection(
                    title:
                        'Metode Pembayaran',

                    subtitle:
                        selectedPayment !=
                                null
                            ? selectedPayment![
                                'name']
                            : 'Pilih pembayaranmu',

                    icon: Icons
                        .account_balance_wallet_outlined,

                    onTap: () async {
                      final result =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PaymentScreen(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedPayment =
                              result;
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

          _buildRincianBayar(),

          _buildBottomBar(),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: const [
                Text(
                  'Pick Up',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF7E8959),
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Pesananmu siap diambil di sini",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            decoration: BoxDecoration(
              color: const Color(
                0xFFF9F9F9,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),

            child:
                DropdownButtonHideUnderline(
              child: DropdownButton<
                  String>(
                value: selectedBooth,

                isExpanded: true,

                items: booths
                    .map(
                      (val) =>
                          DropdownMenuItem(
                        value: val,
                        child: Text(val),
                      ),
                    )
                    .toList(),

                onChanged: (nv) {
                  setState(() {
                    selectedBooth =
                        nv!;
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Detail Pesanan',
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          for (var item in localCartItems)
            _buildCartItem(item),

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
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(14),

            child: (item['image'] !=
                        null &&
                    item['image']
                        .toString()
                        .startsWith(
                            'assets'))
                ? Image.asset(
                    item['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  item['size'] ??
                      '350 ml',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [
                    Text(
                      "Qty: ${item['qty']}",
                      style:
                          const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    Text(
                      "Rp ${formatHarga(item['price'])}",
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        color: Color(
                            0xFF7E8959),
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

      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

      onTap: onTap,
    );
  }

  Widget _buildRincianBayar() {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          const Text(
            'Total Pembayaran',
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            'Rp ${formatHarga(calculateTotal())}',
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
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
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(
                child:
                    CircularProgressIndicator(),
              ),
            );

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

            final newOrder =
                OrderModel(
              id: DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),

              userName:
                  userProvider.name,

              totalAmount:
                  calculateTotal(),

              status:
                  "Sedang Diproses",

              paymentMethod:
                  selectedPayment !=
                          null
                      ? selectedPayment![
                          'name']
                      : 'Tunai',

              address:
                  selectedBooth,

              createdAt:
                  DateTime.now(),

              items: localCartItems
                  .map(
                    (item) => {
                      'name':
                          item['name'],
                      'price':
                          item['price'],
                      'qty':
                          item['qty'],
                      'size':
                          item['size'],
                      'image':
                          item['image'],
                    },
                  )
                  .toList(),

              image: localCartItems
                      .isNotEmpty
                  ? localCartItems
                      .first['image']
                  : '',

              paymentConfirmed:
                  false,
            );

            await orderProvider
                .addOrder(newOrder);

            if (mounted) {
              Navigator.pop(context);

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
            if (mounted) {
              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content:
                      Text("Gagal: $e"),
                  backgroundColor:
                      Colors.red,
                ),
              );
            }
          }
        },

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF7E8959),

          minimumSize:
              const Size(
            double.infinity,
            54,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              30,
            ),
          ),
        ),

        child: const Text(
          'Pesan Sekarang',
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}