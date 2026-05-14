import 'package:flutter/material.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:jamu_saripah/Models/cart_item.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
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
  void _showDeleteConfirmation(CartProvider provider) {
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
          content: const Text("Yakin mau hapus semua isi keranjang?"),
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
                provider.clearCart();
                Navigator.pop(context);
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
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        final cartItems = provider.items;


        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context), // ← cukup pop saja
              ),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: const Text(
              "Keranjang",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF7E8959),
            elevation: 0,
          ),
          body: cartItems.isEmpty
              ? const CartEmptyState()
              : Column(
                  children: [
                    CartHeader(
                      isAllSelected: provider.isAllChecked,
                      canDelete: provider.checkedItemsCount > 0,
                      onToggleAll: () =>
                          provider.checkAll(!provider.isAllChecked),
                      onDeleteAll: () => _showDeleteConfirmation(provider),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: ObjectKey(
                              item,
                            ), // Pakai ObjectKey biar lebih stabil
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              color: AppColors.brown,
                              child: const Icon(
                                Icons.delete_sweep,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (_) => provider.removeItem(
                              index,
                            ), // ✅ Pake removeItem lu
                            child: CartItemWidget(
                              item: item,
                              onToggle: () =>
                                  provider.checkItem(index, !item.isChecked),
                              onIncrement: () =>
                                  provider.incrementQuantity(index),
                              onDecrement: () =>
                                  provider.decrementQuantity(index),
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
                  totalPrice: provider
                      .checkedTotalPrice, // ✅ Sesuaikan nama fungsi provider lu
                  selectedCount: provider.checkedItemsCount,
                  onCheckout: () {
                    print("Checkout ${provider.checkedItemsCount} item");
                  },
                ),
        );
      },
    );
  }
}



