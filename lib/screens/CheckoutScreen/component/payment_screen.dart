import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

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
          'Metode Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN QRIS ---
            _buildMainOption(
              context: context,
              title: 'QRIS',
              leading: _buildIconCircle('QRIS', isText: true),
              showDivider: true,
              paymentData: {'name': 'QRIS', 'icon': Icons.qr_code},
            ),

            // --- BAGIAN KARTU KREDIT ---
            _buildMainOption(
              context: context,
              title: 'Kartu Kredit',
              subtitle:
                  'Minimal pembayaran Rp 10.000 dan mendukung kartu Berlogo Visa, Mastercard dan JCB',
              leading: _buildIconCircle(Icons.credit_card),
              showDivider: false,
              paymentData: {'name': 'Kartu Kredit', 'icon': Icons.credit_card},
            ),

            const Divider(thickness: 8, color: Color(0xFFF1F1F1)),

            // --- METODE PEMBAYARAN LAINNYA ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'Metode Pembayaran Lainnya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            _buildWalletItem(
              context: context,
              name: 'Gopay',
              status: 'Aktifkan Sekarang',
              icon: Icons.account_balance_wallet_outlined,
            ),

            _buildWalletItem(
              context: context,
              name: 'Dana',
              status: 'Aktifkan Sekarang',
              icon: Icons.cloud_outlined,
            ),

            _buildWalletItem(
              context: context,
              name: 'OVO',
              status: 'Aktifkan Sekarang',
              icon: Icons.circle_outlined,
            ),

            _buildWalletItem(
              context: context,
              name: 'blu',
              status: 'Aktifkan Sekarang',
              icon: Icons.water_drop_outlined,
            ),

            _buildWalletItem(
              context: context,
              name: 'ShopeePay',
              status: 'Aktifkan Sekarang',
              icon: Icons.shopping_bag_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // MAIN OPTION
  // =========================
  Widget _buildMainOption({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget leading,
    required bool showDivider,
    required Map<String, dynamic> paymentData,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),

          leading: leading,

          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7E8959),
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,

          onTap: () {
            Navigator.pop(context, paymentData);
          },
        ),

        if (showDivider) const Divider(indent: 16, endIndent: 16),
      ],
    );
  }

  // =========================
  // WALLET ITEM
  // =========================
  Widget _buildWalletItem({
    required BuildContext context,
    required String name,
    required String status,
    required IconData icon,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: const Color(0xFF7E8959), size: 20),
          ),

          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          subtitle: Text(
            status,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF7E8959),
          ),

          onTap: () {
            Navigator.pop(context, {'name': name, 'icon': icon});
          },
        ),

        const Divider(indent: 70),
      ],
    );
  }

  // =========================
  // ICON BULAT
  // =========================
  Widget _buildIconCircle(dynamic content, {bool isText = false}) {
    return Container(
      width: 45,
      height: 45,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Center(
        child: isText
            ? Text(
                content as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(content as IconData, color: const Color(0xFF7E8959)),
      ),
    );
  }
}
