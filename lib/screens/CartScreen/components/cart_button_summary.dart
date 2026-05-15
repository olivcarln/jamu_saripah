import 'package:flutter/material.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:jamu_saripah/screens/CheckoutScreen/checkout.screen.dart';
import 'package:provider/provider.dart';

class CartButtonSummary extends StatelessWidget {
  final int totalPrice;
  final int selectedCount;
  final VoidCallback onCheckout;

  const CartButtonSummary({
    super.key,
    required this.totalPrice,
    required this.selectedCount,
    required this.onCheckout,
  });

  String _formatRupiah(int amount) {
    String str = amount.toString();
    String res = "";
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      res = str[i] + res;
      count++;

      if (count % 3 == 0 && i != 0) {
        res = ".$res";
      }
    }

    return "Rp $res";
  }

  @override
  Widget build(BuildContext context) {

    /// AMBIL CART PROVIDER
    final cartProvider = Provider.of<CartProvider>(context);

    /// ITEM YANG DICENTANG
    final selectedItems = cartProvider.items
        .where((item) => item.isChecked)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// TOTAL
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total ($selectedCount Item)",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                Text(
                  _formatRupiah(totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF7E8959),
                  ),
                ),
              ],
            ),

            /// BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF634E34),

                disabledBackgroundColor:
                    const Color(0xFF634E34).withValues(alpha: 0.5),

                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: selectedCount == 0
                  ? null
                  : () {

                      /// PINDAH KE CHECKOUT + KIRIM CART
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                           cartItems: selectedItems,
                          ),
                        ),
                      );

                      onCheckout();
                    },

              child: const Text(
                "Lanjut",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}