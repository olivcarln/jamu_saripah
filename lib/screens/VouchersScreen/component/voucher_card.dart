import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String expiryDate;
  final String minTransaction;
  final String quota;
  final double discountAmount;
  final String buttonText;
  final bool isSelected;
  final VoidCallback? onClaim;

  const VoucherCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.expiryDate,
    required this.minTransaction,
    required this.quota,
    required this.discountAmount,
    required this.buttonText,
    required this.isSelected,
    this.onClaim,
  });

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isSelected ? 1 : 0.88,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        constraints: const BoxConstraints(minHeight: 160),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B6B4D),
              Color(0xFF6B7548),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// NOTCH KIRI
            Positioned(
              left: -15,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNotch(context),
              ),
            ),

            /// NOTCH KANAN
            Positioned(
              right: -15,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNotch(context),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// TOP
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              subTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildBrandIcon(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Min. Pembelian $minTransaction",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Potongan Rp ${formatHarga(discountAmount.toInt())}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    height: 1,
                    color: Colors.white24,
                  ),

                  const SizedBox(height: 14),

                  /// BOTTOM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Berlaku Sampai",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            expiryDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: onClaim,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFFE7ECD9)
                              : Colors.white,

                          foregroundColor: const Color(0xFF6B7548),

                          elevation: 0,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
      ),
    );
  }

  /// NOTCH TRANSPARAN IKUT BACKGROUND
  Widget _buildNotch(BuildContext context) {
    return Container(
      width: 30,
      height: 30,

      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBrandIcon() {
    return Container(
      width: 45,
      height: 45,

      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white30,
        ),
      ),

      child: const Icon(
        Icons.shopping_bag,
        color: Colors.white,
      ),
    );
  }
}