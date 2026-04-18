import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamu_saripah/Models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> initialItems;

  const CartScreen({super.key, required this.initialItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    // Mengambil data awal dari Home
    cartItems = List.from(widget.initialItems);
  }

  // --- FUNGSI FORMAT RUPIAH ---
  String _formatRupiah(int amount) {
    String strAmount = amount.toString();
    String result = "";
    int count = 0;
    for (int i = strAmount.length - 1; i >= 0; i--) {
      result = strAmount[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) result = "." + result;
    }
    return "Rp $result";
  }

  @override
  Widget build(BuildContext context) {
    // LOGIKA OTOMATIS: Dihitung setiap kali layar di-build ulang
    int selectedQty = cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + item.quantity);

    int totalPrice = cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));

    bool isAllSelected = cartItems.isNotEmpty && 
        cartItems.every((item) => item.isChecked);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("Keranjang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF7E8959),
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildSelectAllHeader(isAllSelected),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildDismissibleItem(cartItems[index], index);
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty 
          ? null 
          : _buildBottomSummary(totalPrice, selectedQty),
    );
  }

  // 1. HEADER SELECT ALL
  Widget _buildSelectAllHeader(bool isAllSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                for (var item in cartItems) {
                  item.isChecked = !isAllSelected;
                }
              });
            },
            child: Icon(
              isAllSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: const Color(0xFF7E8959),
            ),
          ),
          const SizedBox(width: 12),
          const Text("Pilih Semua", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  // 2. CARD PRODUK (DENGAN QUANTITY)
  Widget _buildCartCard(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => item.isChecked = !item.isChecked),
            child: Icon(
              item.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: const Color(0xFF7E8959),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.image, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatRupiah(item.price), style: const TextStyle(fontWeight: FontWeight.bold)),
                    
                    // COUNTER PLUS MINUS
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(Icons.remove, () {
                            if (item.quantity > 1) {
                              setState(() => item.quantity--);
                            }
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          _buildQtyBtn(Icons.add, () {
                            setState(() => item.quantity++);
                          }),
                        ],
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

  // 3. BOTTOM SUMMARY (TOTAL HARGA & JUMLAH)
  Widget _buildBottomSummary(int total, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total ($count Item)", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  _formatRupiah(total), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF7E8959)),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF634E34),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: count == 0 ? null : () { /* Checkout */ },
              child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER TOMBOL QUANTITY
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color(0xFF7E8959),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // DISMISSIBLE (SWIPE TO DELETE)
  Widget _buildDismissibleItem(CartItem item, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
      ),
      onDismissed: (_) {
        setState(() => cartItems.removeAt(index));
      },
      child: _buildCartCard(item, index),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/cartShopping.svg', height: 180, color: const Color(0xFF7E8959)),
          const SizedBox(height: 20),
          const Text("Keranjang kosong nih!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}