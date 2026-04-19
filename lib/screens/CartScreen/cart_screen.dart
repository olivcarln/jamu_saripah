import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'components/cart_header.dart';
import 'components/cart_item.dart';
import 'components/cart_empty_state.dart';
import 'components/cart_button_summary.dart';

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
    cartItems = List.from(widget.initialItems);
  }

  // --- INI FUNGSI POP-UP NYA IP, JANGAN SAMPE KETINGGALAN ---
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Hapus Keranjang?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Yakin mau hapus semua isi keranjang lu?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  cartItems.clear(); // Ngosongin list total
                });
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text(
                "Ya, Hapus Semua",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung-hitungan status keranjang
    int selectedQty = cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + item.quantity);

    int totalPrice = cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));

    bool isAllSelected =
        cartItems.isNotEmpty && cartItems.every((item) => item.isChecked);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF7E8959),
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? const CartEmptyState()
          : Column(
              children: [
                // KOMPONEN HEADER DENGAN FUNGSI POP-UP
                // Cari bagian CartHeader di dalam build:
                CartHeader(
                  isAllSelected: isAllSelected,
                  canDelete:
                      selectedQty >
                      0, // Ini yang nentuin tombol hapus muncul atau nggak
                  onToggleAll: () {
                    setState(() {
                      for (var item in cartItems) {
                        item.isChecked = !isAllSelected;
                      }
                    });
                  },
                  onDeleteAll:
                      _showDeleteConfirmation, // Panggil fungsi pop-up yang udah lu buat
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: AppColors.brown,
                          child: const Icon(
                            Icons.delete_sweep,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (_) {
                          setState(() => cartItems.removeAt(index));
                        },
                        child: CartItemWidget(
                          item: item,
                          onToggle: () =>
                              setState(() => item.isChecked = !item.isChecked),
                          onIncrement: () => setState(() => item.quantity++),
                          onDecrement: () {
                            if (item.quantity > 1) {
                              setState(() => item.quantity--);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : CartButtonSummary(
              totalPrice: totalPrice,
              selectedCount: selectedQty,
              onCheckout: () {
                // ignore: avoid_print
                print("Checkout diklik!");
              },
            ),
    );
  }
}
