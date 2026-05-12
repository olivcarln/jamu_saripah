import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';
import 'package:jamu_saripah/screens/orderscreen/order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final int? totalPrice;
  final int? selectedCount;


  const CheckoutScreen({super.key, this.totalPrice, this.selectedCount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Setup data cabang
  final List<String> cabangJamu = [
    'Lippo Mall Karawaci',
    'Plaza Atrium Jakarta',
    'Gedung Jam Sostek',
  ];

  String selectedCabang = 'Lippo Mall Karawaci'; // Default pilihan
  bool perluTasBelanja = false;
  int hargaTas = 3000;
  int diskonVoucher = 0; 

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
      0, (sum, item) => sum + (item['price'] * item['qty'] as int));
  
  int totalAkhir = perluTasBelanja ? totalProduk + hargaTas : totalProduk;
  
  // Logika pengurangan voucher ada di sini
  return (totalAkhir - diskonVoucher).toInt(); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
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
                  const Text(
                    'Detail Pesanan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    ...cartItems.map((item) => _buildCartItem(item)),

                  const Divider(),

                  const SizedBox(height: 12),
                  const Text(
                    'Ada tambahan lagi?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  AddingMenuScreen(
                    onAddTap: (n, s, p) => setState(
                      () => cartItems.add({
                        'name': n,
                        'size': s,
                        'price': p,
                        'qty': 1,
                      }),
                    ),
                  ),
                ],
              ),
            ),

            ShoppingBagScreen(
              isSelected: perluTasBelanja,
              harga: hargaTas,
              onChanged: (val) => setState(() => perluTasBelanja = val),
            ),

            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            _buildClickableSection(
              title: 'Voucher Diskon',
              subtitle: diskonVoucher > 0
                  ? 'Hemat Rp ${formatHarga(diskonVoucher)}' // UI berubah kalau voucher aktif
                  : 'yuk lebih hemat dengan voucher',
              icon: Icons.confirmation_num_outlined,
              onTap: () async {
                // Tunggu hasil (nominal diskon) dari halaman voucher
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const VoucherScreen()),
                );

                // Kalau ada voucher yang dipilih, update harganya
                if (result != null && result is int) {
                  setState(() {
                    diskonVoucher = result;
                  });
                }
              },
            ),
            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
            _buildClickableSection(
              title: 'Metode Pembayaran',
              subtitle: 'QRIS',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const PaymentScreen()),
              ),
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
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: Color(0xFF7E8959),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ambil di Toko",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E8959),
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Pesanan disiapkan oleh cabang pilihanmu',
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF7E8959).withOpacity(0.3)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCabang,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF7E8959),
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(
              12,
            ), // Border radius untuk menu yang muncul
            items: cabangJamu.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xFF7E8959),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCabang = newValue!;
              });
            },
          ),
        ),
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
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF7E8959), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildRincianSection() {
  int subtotal = cartItems.fold(
    0,
    (sum, item) => sum + (item['price'] * item['qty'] as int),
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _rowHarga('Harga', subtotal),
        
        // Baris Tas Belanja
        if (perluTasBelanja) _rowHarga('Tas Belanja', hargaTas),
        
        // BARU: Baris Diskon Voucher (hanya muncul kalau diskon > 0)
        if (diskonVoucher > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Diskon Voucher',),
                Text(
                  '- Rp ${formatHarga(diskonVoucher)}',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
        const Divider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Rp ${formatHarga(calculateTotal())}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FCF3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.stars, color: Color(0xFF7E8959), size: 18),
              SizedBox(width: 8),
              Text(
                'Kamu berpotensi mendapatkan 4 Jamu Poin',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        ),
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

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: const Color(0xFF8B4513),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (cartItems.length <= 1) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Hapus Pesanan?"),
                content: const Text(
                  "Ini adalah pesanan terakhirmu. Yakin ingin menghapusnya?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Hapus",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return true;
      },
      onDismissed: (direction) => setState(() => cartItems.remove(item)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          item['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item['size']),
        trailing: Text(
          'Rp ${formatHarga(item['price'])}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7E8959),
          ),
        ),
      ),
    );
  }
}
