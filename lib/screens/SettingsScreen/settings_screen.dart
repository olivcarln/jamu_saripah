import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/screens/SettingsScreen/components/notifications_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF8DA05E);
    final Color backgroundColor = const Color(0xFFF9FAf7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("Aplikasi"),
            _buildSettingCard(
              icon: Icons.notifications_none_rounded,
              title: "Notifikasi",
              subtitle: "Atur pemberitahuan pesanan & promo",
              color: primaryColor,
            onTap: () {
    // Navigasi ke halaman pengaturan notifikasi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationSettingsScreen(),
      ),
    );
  },
            ),
            
            const SizedBox(height: 20),
            _buildSectionLabel("Keamanan & Data"),
            _buildSettingCard(
              icon: Icons.lock_outline_rounded,
              title: "Ubah Kata Sandi",
              subtitle: "Perbarui password akun Anda",
              color: primaryColor,
              onTap: () {
                //TODO: masukin ubah sandi screen
                print("Navigasi ke Ubah Password");
              },
            ),
            _buildSettingCard(
              icon: Icons.delete_sweep_outlined,
              title: "Hapus Cache",
              subtitle: "Bersihkan ruang penyimpanan aplikasi",
              color: primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cache berhasil dibersihkan")),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionLabel("Zona Bahaya"),
            _buildSettingCard(
              icon: Icons.person_remove_outlined,
              title: "Hapus Akun",
              subtitle: "Hapus data akun secara permanen",
              color: Colors.redAccent,
              onTap: () => _showDeleteAccountDialog(context),
              isCritical: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isCritical = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCritical ? Colors.redAccent : Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Akun?"),
        content: const Text("Semua data Anda akan dihapus secara permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              // Tambahkan logika hapus akun di sini jika perlu
              Navigator.pop(context);
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}