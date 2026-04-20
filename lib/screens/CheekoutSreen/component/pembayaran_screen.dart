import 'package:flutter/material.dart';

class PembayaranScreen extends StatelessWidget {
  const PembayaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO:belom masukin img
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color:Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
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
              title: 'QRIS',
              leading: _buildIconCircle('QRIS', isText: true),
              showDivider: true,
            ),

            // --- BAGIAN KARTU KREDIT ---
            _buildMainOption(
              title: 'Kartu Kredit',
              subtitle: 'Minimal pembayaran Rp 10.000 dan mendukung kartu Berlogo Visa, Mastercard dan JCB',
              leading: _buildIconCircle(Icons.credit_card),
              showDivider: false,
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

            _buildWalletItem('Gopay', 'Aktifkan Sekarang', Icons.account_balance_wallet_outlined),
            _buildWalletItem('Dana', 'Aktifkan Sekarang', Icons.cloud_outlined),
            _buildWalletItem('OVO', 'Aktifkan Sekarang', Icons.circle_outlined),
            _buildWalletItem('blu', 'Aktifkan Sekarang', Icons.water_drop_outlined),
            _buildWalletItem('ShopeePay', 'Aktifkan Sekarang', Icons.shopping_bag_outlined),
          ],
        ),
      ),
    );
  }

  // Widget untuk QRIS & Kartu Kredit
  Widget _buildMainOption({required String title, String? subtitle, required Widget leading, required bool showDivider}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: leading,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: subtitle != null 
            ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF7E8959), fontWeight: FontWeight.w500)) 
            : null,
          onTap: () {},
        ),
        if (showDivider) const Divider(indent: 16, endIndent: 16),
      ],
    );
  }

  // Widget untuk daftar E-Wallet
  Widget _buildWalletItem(String name, String status, IconData icon) {
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
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(status, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7E8959)),
          onTap: () {},
        ),
        const Divider(indent: 70),
      ],
    );
  }

  // Helper untuk buat icon bulat
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
          ? Text(content as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
          : Icon(content as IconData, color: const Color(0xFF7E8959)),
      ),
    );
  }
}