import 'package:flutter/material.dart';
import 'package:jamu_saripah/Provider/order_provider.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/orderscreen/order_history_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/select_method_screen.dart';
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

  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = [
      {
        'name': 'Total Pesanan (${widget.selectedCount ?? 0} Item)',
        'size': 'Item dari Keranjang',
        'price': widget.totalPrice ?? 0,
        'qty': 1,
      }
    ];
  }

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
  // Bagian Arrow ada di sini
 leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryOlive),
  onPressed: () {
    // Panggil fungsi dialog di sini
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Batalkan Pesanan?"),
          content: const Text("Data yang kamu isi mungkin tidak akan tersimpan."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog saja
              child: const Text("Lanjut Checkout", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Balik ke halaman sebelumnya (Batal)
              },
              child: const Text("Ya, Batal", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  },
),
  title: const Text(
    'Checkout',
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
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
                  // Menampilkan list produk dengan fitur slide to delete
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Belum ada pesanan", style: TextStyle(color: Colors.grey)),
                    )
                  else
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
            const SizedBox(height: 10),
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
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              currentMethod == 'Delivery' ? Icons.local_shipping : Icons.person_pin_circle,
              color: const Color(0xFF7E8959),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentMethod, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7E8959), fontSize: 16)),
                Text(currentMethod == 'Delivery' ? 'Tinggal pesan, kami yang antar' : 'Datang, ambil, beres!', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectMethodScreen()));
                if (result != null && result is String) setState(() => currentMethod = result);
              },
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 15)),
              child: const Text('Ubah', style: TextStyle(color: Colors.black, fontSize: 12)),
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
        isDelivery ? Icons.location_on_outlined : Icons.home_outlined, 
        color: const Color(0xFF7E8959)
      ),
      title: Text(
        isDelivery ? 'Rumah - Jatiasih' : 'Jamu Saripah - Anggrek Cakra', 
        style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      subtitle: Text(
        isDelivery 
            ? 'Jl. Melati No. 12, Bekasi (Alamat Kamu)' 
            : '1.4 km dari lokasimu (Alamat Toko)'
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildClickableSection({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF7E8959), size: 22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
    );
  }

  Widget _buildRincianSection() {
    int subtotal = cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty'] as int));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _rowHarga('Harga', subtotal),
          if (perluTasBelanja) _rowHarga('Tas Belanja', hargaTas),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Rp ${formatHarga(calculateTotal())}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF9FCF3), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.stars, color: Color(0xFF7E8959), size: 18),
                SizedBox(width: 8),
                Text('Kamu berpotensi mendapatkan 4 Jamu Poin', style: TextStyle(fontSize: 12, color: Colors.black54)),
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
    // Memberikan warna background putih agar tidak tembus ke body
    color: Colors.white, 
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 0,      // Kita nol kan top padding di sini
          bottom: 20,   // Jarak aman untuk navigasi bar
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // SANGAT PENTING agar tidak narik ke atas
          children: [
            // Garis tipis opsional agar terpisah dari info poin
            const Divider(height: 1, color: Color(0xFFF1F1F1)), 
            const SizedBox(height: 12), // Jarak manual antara divider/poin ke tombol
            ElevatedButton(
              onPressed: () {
                final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                orderProvider.addOrder(OrderModel(
                  title: cartItems[0]['name'],
                  date: DateTime.now().toString().substring(0, 16),
                  price: calculateTotal(),
                  status: "Diproses",
                  method: currentMethod,
                ));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E8959),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: const Text(
                'Pesan Sekarang',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildAddMoreButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Ada tambahan lagi?', style: TextStyle(fontWeight: FontWeight.bold)),
        OutlinedButton(
          onPressed: () => setState(() => showSpecialPackage = !showSpecialPackage),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF7E8959)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) return const Color(0xFF7E8959);
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) return Colors.white;
              return const Color(0xFF7E8959);
            }),
          ),
          child: const Text('Tambah'),
        )
      ],
    );
  }

Widget _buildCartItem(Map<String, dynamic> item) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: (AppColors.brown),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      // LOGIKA KONFIRMASI JIKA TINGGAL 1 ITEM
      confirmDismiss: (direction) async {
        if (cartItems.length <= 1) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Hapus Pesanan?"),
                content: const Text("Ini adalah pesanan terakhirmu. Yakin ingin menghapusnya?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        }
        return true; // Jika lebih dari 1, langsung hapus tanpa tanya
      },
      onDismissed: (direction) {
        setState(() {
          cartItems.remove(item);
        });
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item['size']),
        trailing: Text(
          'Rp ${formatHarga(item['price'])}', 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7E8959))
        ),
      ),
    );
  }
}