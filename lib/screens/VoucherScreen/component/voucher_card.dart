import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String expiryDate;
  final String minTransaction;

  const VoucherCard({
    super.key,
    this.title = 'Diskon 35% Special Jamu Ny. Saripah',
    this.subTitle = 'Min. Pembelian 1 Produck',
    this.expiryDate = '31 Maret 2026',
    this.minTransaction = 'Rp 100.000,-',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8D6E63), Color(0xFF7E8959)], // Cokelat ke Hijau
        ),
      ),
      child: Stack(
        children: [
          // Efek Notch/Lubang Samping
          Positioned(left: -15, top: 55, child: _buildNotch()),
          Positioned(right: -15, top: 55, child: _buildNotch()),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(subTitle, 
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    _buildIcon(),
                  ],
                ),
                const Spacer(),
                const Divider(color: Colors.white38, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn('Berlaku Sampai', expiryDate),
                    _buildInfoColumn('Min. Transaksi', minTransaction, crossAxis: CrossAxisAlignment.end),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotch() => Container(
    height: 30, width: 30, 
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
  );

  Widget _buildIcon() => Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
  );

  Widget _buildInfoColumn(String label, String value, {CrossAxisAlignment crossAxis = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}