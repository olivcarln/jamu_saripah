import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Logic: State untuk menyimpan status toggle
  bool _orderUpdate = true;
  bool _promoUpdate = false;
  bool _chatNotification = true;
  bool _securityAlert = true;

  // Logic: Fungsi untuk menyimpan perubahan
  void _saveSettings() {
    // Di sini nanti kamu bisa tambahkan fungsi simpan ke Database/API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pengaturan berhasil disimpan!"),
        backgroundColor: AppColors.primaryOlive,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Logic: Menengahkan teks di AppBar
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "TRANSAKSI & AKTIVITAS",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildNotificationItem(
            title: "Status Pesanan",
            subtitle: "Dapatkan update real-time tentang pesananmu.",
            icon: Icons.local_shipping_outlined,
            value: _orderUpdate,
            onChanged: (val) => setState(() => _orderUpdate = val),
          ),
          _buildNotificationItem(
            title: "Chat & Diskusi",
            subtitle: "Notifikasi pesan baru dari penjual atau pembeli.",
            icon: Icons.chat_outlined,
            value: _chatNotification,
            onChanged: (val) => setState(() => _chatNotification = val),
          ),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "PROMO & UPDATE",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildNotificationItem(
            title: "Promo & Voucher",
            subtitle: "Info diskon eksklusif dan flash sale harian.",
            icon: Icons.confirmation_number_outlined,
            value: _promoUpdate,
            onChanged: (val) => setState(() => _promoUpdate = val),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "KEAMANAN",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.bold, 
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          _buildNotificationItem(
            title: "Peringatan Keamanan",
            subtitle: "Notifikasi saat ada login baru atau ganti password.",
            icon: Icons.security_outlined,
            value: _securityAlert,
            onChanged: (val) => setState(() => _securityAlert = val),
          ),
          
          const SizedBox(height: 40),
          
          // Perbaikan Error: Menggunakan .only untuk menyisipkan parameter bottom
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOlive,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Simpan Perubahan", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget Helper untuk item list agar kode bersih
  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: CircleAvatar(
          backgroundColor: AppColors.primaryOlive.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primaryOlive, size: 20),
        ),
        title: Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Text(
          subtitle, 
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        value: value,
        activeThumbColor: AppColors.primaryOlive,
        onChanged: onChanged,
      ),
    );
  }
}