import 'package:flutter/material.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class VoucherCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String expiryDate;
  final String minTransaction;
  final String quota;
  final double discountAmount;
  final String buttonText;
  final VoidCallback? onClaim;

  const VoucherCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.expiryDate,
    required this.minTransaction,
    required this.quota,
    required this.discountAmount,
    this.onClaim,
    required this.buttonText,
  });

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> {
  bool isUsed = false;

  void _applyVoucher() async {
    final cartProvider = context.read<CartProvider>();

    /// CEK APAKAH SUDAH ADA VOUCHER
    if (cartProvider.voucherDiscount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 2),
          content: const Text(
            "Voucher lain sudah digunakan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );

      return;
    }

    /// APPLY DISKON
    cartProvider.applyVoucher(widget.discountAmount);

    /// FIRESTORE CALLBACK
    if (widget.onClaim != null) {
      await Future.sync(() => widget.onClaim!());
    }

    /// HILANGKAN CARD
    setState(() {
      isUsed = true;
    });

    /// SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6B7548),
        elevation: 10,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Voucher berhasil digunakan!",
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

  @override
  Widget build(BuildContext context) {
    /// JIKA SUDAH DIGUNAKAN → HILANG
    if (isUsed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B6B4D), Color(0xFF6B7548)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -15,
            top: 0,
            bottom: 0,
            child: Center(child: _buildNotch()),
          ),

          Positioned(
            right: -15,
            top: 0,
            bottom: 0,
            child: Center(child: _buildNotch()),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                widget.subTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildBrandIcon(),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Min. Pembelian ${widget.minTransaction}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Potongan Rp ${widget.discountAmount.toInt()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(height: 1, color: Colors.white30),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Berlaku Sampai',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            widget.expiryDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 35,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,

                          foregroundColor: const Color(0xFF6B7548),

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),

                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),

                        onPressed: _applyVoucher,

                        child: Text(
                          widget.buttonText,

                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildNotch() {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBrandIcon() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: const Icon(Icons.shopping_bag, color: Colors.white),
      ),
    );
  }
}
