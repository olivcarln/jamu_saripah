import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6E8B4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // SECTION: UTAMA (QRIS & KARTU KREDIT)
            _buildMainPaymentOption(
              icon: Icons.qr_code_scanner, 
              title: "QRIS",
            ),
            const Divider(indent: 20, endIndent: 20),
            _buildMainPaymentOption(
              icon: Icons.credit_card,
              title: "Kartu Kredit",
              subtitle: "Minimal pembayaran Rp 10.000 dan mendukung kartu Berlogo Visa, Mastercard dan JCB",
            ),

            const SizedBox(height: 20),

            // SECTION: METODE LAINNYA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFFF8F8F8), // Background abu muda untuk header
              child: const Text(
                "Metode Pembayaran Lainnya",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            // DAFTAR E-WALLET
            _buildOtherPaymentItem(
              title: "Gopay",
              iconPath: 'assets/gopay.png',
              color: Colors.blue,
            ),
            _buildOtherPaymentItem(
              title: "Dana",
              iconPath: 'assets/dana.png',
              color: Colors.blueAccent,
            ),
            _buildOtherPaymentItem(
              title: "OVO",
              iconPath: 'assets/ovo.png',
              color: Colors.purple,
            ),
            _buildOtherPaymentItem(
              title: "blu",
              iconPath: 'assets/blu.png',
              color: Colors.cyan,
            ),
            _buildOtherPaymentItem(
              title: "ShopeePay",
              iconPath: 'assets/shopeepay.png',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMainPaymentOption({required IconData icon, required String title, String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6E8B4F), height: 1.5),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk list E-Wallet di bawah
  Widget _buildOtherPaymentItem({required String title, required String iconPath, required Color color}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Icon(Icons.account_balance_wallet, color: color, size: 24), // Ganti dengan Image.asset(iconPath)
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: const Text(
            "Aktifkan Sekarang",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF6E8B4F)),
          onTap: () {
            // Logic integrasi pembayaran
          },
        ),
        const Divider(indent: 20, endIndent: 20, height: 1),
      ],
    );
  }
}