import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/adding_menu_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/shopping_bag_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/payment_screen.dart';
import 'package:jamu_saripah/screens/CheckoutSreen/component/select_method_screen.dart';
import 'package:jamu_saripah/screens/VouchersScreen/voucher_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalPrice;
  final int selectedCount;

  const CheckoutScreen({
    super.key,
    required this.totalPrice,
    required this.selectedCount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int diskonVoucher = 0;
  int ongkir = 15000;

  String _formatRupiah(int amount) {
    String str = amount.toString();
    String res = "";
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      res = str[i] + res;
      count++;
      if (count % 3 == 0 && i != 0) res = "." + res;
    }
    return "Rp $res";
  }

  @override
  Widget build(BuildContext context) {
    int totalBayar = (widget.totalPrice + ongkir) - diskonVoucher;
    if (totalBayar < 0) totalBayar = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E8959),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SelectMethodScreen(),
            const Divider(thickness: 1),
            
            const SizedBox(height: 10),
            ShoppingBagScreen(
              isSelected: true,
              harga: widget.totalPrice,
              onChanged: (bool value) {},
            ),

            const SizedBox(height: 20),
            
            AddingMenuScreen(
              onAddTap: (String nama, String size, int harga) {
                Navigator.pop(context); 
              },
            ),

            const Divider(thickness: 1),

            // FIXED: Membatasi trailing agar tidak menyebabkan infinite size
            ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VoucherScreen()),
                );
                if (result != null && result is int) {
                  setState(() { diskonVoucher = result; });
                }
              },
              leading: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF7E8959)),
              title: const Text('Voucher Jamu Saripah'),
              trailing: IntrinsicWidth( // Agar Row tidak mengambil lebar tak terhingga
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      diskonVoucher > 0 ? "- ${_formatRupiah(diskonVoucher)}" : "Pakai Voucher",
                      style: TextStyle(
                        color: diskonVoucher > 0 ? Colors.red : Colors.grey,
                        fontWeight: diskonVoucher > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1),

            const PaymentScreen(),
            
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _rowPrice("Subtotal", _formatRupiah(widget.totalPrice)),
                  const SizedBox(height: 8),
                  _rowPrice("Ongkir", _formatRupiah(ongkir)),
                  if (diskonVoucher > 0) ...[
                    const SizedBox(height: 8),
                    _rowPrice("Diskon Voucher", "- ${_formatRupiah(diskonVoucher)}", isRed: true),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 120), 
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(totalBayar),
    );
  }

  Widget _rowPrice(String label, String value, {bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: TextStyle(
          fontSize: 14,
          color: isRed ? Colors.red : Colors.black,
          fontWeight: isRed ? FontWeight.bold : FontWeight.normal,
        )),
      ],
    );
  }

  Widget _buildBottomBar(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Tagihan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(_formatRupiah(total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF7E8959))),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF634E34),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Logika proses pesanan
              },
              child: const Text("Buat Pesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}