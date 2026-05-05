import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VouchersScreen/payday_screen.dart';

class VoucherHeader extends StatefulWidget {
  final bool isVoucherActive;
  final VoidCallback? onVoucherTap;
  final VoidCallback? onPaydayTap;

  const VoucherHeader({
    super.key,
    this.isVoucherActive = true,
    this.onVoucherTap,
    this.onPaydayTap,
  });

  @override
  State<VoucherHeader> createState() => _VoucherHeaderState();
}

class _VoucherHeaderState extends State<VoucherHeader> {
  bool isVoucherHovered = false;
  bool isPaydayHovered = false;

  final primaryColor = const Color(0xFF6E864C);
  final hoverColor = const Color(0xFF6D4C41);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Center(
            child: Text(
              "Vouchers",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// INPUT PROMO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Dapat kode promo? Masukkan di sini",
                    style: TextStyle(
                      color: primaryColor.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// TAB MENU
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ini akan mendorong "Payday!" ke pojok kanan
            children: [
              _buildTab(
                title: "Vouchers",
                isHovered: isVoucherHovered,
                isActive: widget.isVoucherActive,
                onHover: (value) =>
                    setState(() => isVoucherHovered = value),
                onTap: widget.onVoucherTap ?? () {}
                
              ),

              const SizedBox(width: 20),

              _buildTab(
          
                title: "Payday!",
                isHovered: isPaydayHovered,
                isActive: !widget.isVoucherActive,
                onHover: (value) =>
                    setState(() => isPaydayHovered = value),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaydayScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isHovered,
    required bool isActive,
    required Function(bool) onHover,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive || isHovered
                    ? primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive || isHovered
                  ? hoverColor
                  : primaryColor,
              fontSize: 16,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}