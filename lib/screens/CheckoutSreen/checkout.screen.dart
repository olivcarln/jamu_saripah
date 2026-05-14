import 'package:flutter/material.dart';
import 'package:jamu_saripah/Provider/order_provider.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:provider/provider.dart';


class CheckoutScreen extends StatefulWidget {
  final int? totalPrice;
  final int? selectedCount;


  const CheckoutScreen({super.key, this.totalPrice, this.selectedCount});


  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}


class _CheckoutScreenState extends State<CheckoutScreen> {
  String currentMethod = 'Delivery';
  bool showSpecialPackage = false;
  bool perluTasBelanja = false;
  int hargaTas = 3000;
  String selectedBooth = 'Plaza Atria Jakarta';
  List<String> booths = ['Plaza Atria Jakarta', 'Gedung Jamsostek', 'Lippo Mal Karawaci'];


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
        'price': widget.totalPrice ?? 19500,
        'qty': 1,
        'image': 'assets/images/beras_kencur.png'
      }
    ];
  }


  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }


  int calculateTotal() {
    int totalProduk = cartItems.fold(0, (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)));
    int total = perluTasBelanja ? totalProduk + hargaTas : totalProduk;
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                  _buildDetailPesananSection(),
                 
                  if (showSpecialPackage)
                    AddingMenuScreen(
                      onAddTap: (n, s, p) => setState(() =>
                        cartItems.add({'name': n ?? 'Menu', 'size': s ?? '', 'price': p ?? 0, 'qty': 1, 'image': ''})
                      ),
                    ),


                  ShoppingBagScreen(
                    isSelected: perluTasBelanja,
                    harga: hargaTas,
                    onChanged: (val) => setState(() => perluTasBelanja = val),
                  ),
                 
                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                  _buildClickableSection(
                    title: appliedVoucher != null ? 'Voucher Dipakai' : 'Voucher Diskon',
                    subtitle: appliedVoucher != null ? 'Potongan Rp ${formatHarga(appliedVoucher!['discount'])}' : 'yuk lebih hemat dengan voucher',
                    icon: Icons.confirmation_num_outlined,
                    onTap: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const VoucherScreen()));
                      if (result != null) setState(() => appliedVoucher = result);
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
                        setState(() => selectedPayment = result);
                      }
                    },
                  ),
                  const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F1F1)),
          _buildRincianSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }


  Widget _buildDetailPesananSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                      fontSize: 16),
                ),
                Text(
                  currentMethod == 'Delivery'
                      ? 'Tinggal pesan, kami yang antar'
                      : 'Datang, ambil, beres!',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                      builder: (context) => const SelectMethodScreen()),
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
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 15),
              ),
              child: const Text('Ubah',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item['size'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item['image'] ?? '',
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 75, height: 75, color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rp ${formatHarga(item['price'] ?? 0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7E8959))),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text("Ubah",
                    style: TextStyle(color: Color(0xFF7E8959), decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF7E8959).withOpacity(0.5), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove, size: 18, color: Color(0xFF7E8959)),
                          onPressed: () => setState(() {
                            if(item['qty'] > 1) {
                              item['qty']--;
                            } else {
                              // Hapus item jika jumlahnya 1 dan tombol minus ditekan
                              cartItems.removeAt(index);
                            }
                          }),
                        ),
                      ),
                      Text('${item['qty']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add, size: 18, color: Color(0xFF7E8959)),
                          onPressed: () => setState(() => item['qty']++),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }


  Widget _buildDeliveryMode() {
    return Container(
      color: const Color(0xFFF9FCF3), padding: const EdgeInsets.all(16),
      child: const Row(children: [
          Icon(Icons.person_pin_circle, color: Color(0xFF7E8959), size: 24),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pick Up', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7E8959), fontSize: 16)),
            Text('Datang, ambil, beres!', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ])),
      ]),
    );
  }


  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Pesananmu siap diambil di sini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBooth, isExpanded: true,
              items: booths.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (nv) => setState(() => selectedBooth = nv!),
            ),
          ),
        ),
      ]),
    );
  }


  Widget _buildClickableSection({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF7E8959)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }


  Widget _buildRincianSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text('Rp ${formatHarga(harga)}'),
        ],
      ),
    );
  }


  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7E8959),
          minimumSize: const Size(double.infinity, 54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('Pesan Sekarang',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}

