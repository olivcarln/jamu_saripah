import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/orderscreen/order_history_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/select_method_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String currentMethod = 'Delivery';
  bool showSpecialPackage = false;
  bool perluTasBelanja = false;
  int hargaTas = 3000;

  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Jamu Beras Kencur',
      'size': '350 ml',
      'price': 19500,
      'qty': 1,
    }
  ];

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  int calculateTotal() {
    int totalProduk = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['qty'] as int));
    return perluTasBelanja ? totalProduk + hargaTas : totalProduk;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDeliveryMode(),
            _buildLocationInfo(),
            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  ...cartItems.map((item) => _buildCartItem(item)),
                  const Divider(),
                  _buildAddMoreButton(),
                ],
              ),
            ),
            if (showSpecialPackage)
              AddingMenuScreen(
                  onAddTap: (n, s, p) => setState(() =>
                      cartItems.add({'name': n, 'size': s, 'price': p, 'qty': 1}))),
            ShoppingBagScreen(
              isSelected: perluTasBelanja,
              harga: hargaTas,
              onChanged: (val) => setState(() => perluTasBelanja = val),
            ),
            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            _buildClickableSection(
              title: 'Voucher Diskon',
              subtitle: 'yuk lebih hemat dengan voucher',
              icon: Icons.confirmation_num_outlined,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const VoucherScreen())),
            ),
            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            _buildClickableSection(
              title: 'Metode Pembayaran',
              subtitle: 'QRIS',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const PaymentScreen())),
            ),
            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            _buildRincianSection(),
            const SizedBox(height: 20),
          ],
        ),
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

  Widget _buildLocationInfo() {
    return const ListTile(
      leading: Icon(Icons.home_outlined, color: Color(0xFF7E8959)),
      title: Text('Anggrek Cakra', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('1.4 km dari lokasimu'),
    );
  }

  Widget _buildClickableSection(
      {required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF7E8959), size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
    );
  }

  Widget _buildRincianSection() {
    int subtotal = cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['qty'] as int));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _rowHarga('Harga', subtotal),
          if (perluTasBelanja) _rowHarga('Tas Belanja', hargaTas),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Rp ${formatHarga(calculateTotal())}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFF9FCF3),
                borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.stars, color: Color(0xFF7E8959), size: 18),
                SizedBox(width: 8),
                Text('Kamu berpotensi mendapatkan 4 Jamu Poin',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowHarga(String label, int harga) {
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

  Widget _buildAddMoreButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Ada tambahan lagi?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        OutlinedButton(
          onPressed: () => setState(() => showSpecialPackage = !showSpecialPackage),
          child: const Text('Tambah'),
        )
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item['name'],
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(item['size']),
      trailing: Text('Rp ${formatHarga(item['price'])}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF7E8959))),
    );
  }
}