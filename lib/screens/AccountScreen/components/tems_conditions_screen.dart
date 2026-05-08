import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna hijau zaitun soft sesuai foto
    final Color primaryColor = const Color(0xFF8DA05E); 
    final Color textColor = const Color(0xFF4A4A4A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.withValues(alpha: 0.2), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildSectionTitle("Akun & Keamanan"),
                _buildExpansionTile("1. Pendaftaran Akun", "Pengguna wajib memberikan data yang valid dan menjaga kerahasiaan password akun demi keamanan transaksi.", primaryColor, textColor),
                
                _buildSectionTitle("Transaksi"),
                _buildExpansionTile("2. Metode Pembayaran", "Tersedia berbagai pilihan pembayaran aman melalui bank transfer, e-wallet, dan fitur lainnya yang terverifikasi.", primaryColor, textColor),
                _buildExpansionTile("3. Konfirmasi Pesanan", "Pesanan akan diproses segera setelah sistem kami menerima konfirmasi pembayaran yang sah dari Anda.", primaryColor, textColor),
                
                _buildSectionTitle("Pengiriman & Retur"),
                _buildExpansionTile("4. Kebijakan Pengiriman", "Barang dikirim melalui mitra logistik. Estimasi waktu sampai sepenuhnya bergantung pada layanan kurir yang dipilih.", primaryColor, textColor),
                _buildExpansionTile("5. Syarat Pengembalian", "Retur hanya diterima jika menyertakan video unboxing lengkap tanpa edit dan dilakukan maksimal 2 hari setelah barang diterima.", primaryColor, textColor),
                
                _buildSectionTitle("Lainnya"),
                _buildExpansionTile("6. Hak Kekayaan Intelektual", "Seluruh materi dalam aplikasi ini (teks, logo, gambar) adalah milik kami dan dilindungi oleh undang-undang yang berlaku.", primaryColor, textColor),
              ],
            ),
          ),
          
          // Tombol Hubungi Kami / Setuju (Sesuai gaya foto)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.headset_mic_outlined, size: 20),
                label: const Text("Hubungi Kami", style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8DA05E),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content, Color primary, Color text) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 0.5),
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primary,
          collapsedIconColor: Colors.grey,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            title,
            style: TextStyle(
              color: text,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}