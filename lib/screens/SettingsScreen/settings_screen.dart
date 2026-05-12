import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// --- IMPORT HALAMAN ---
// Pastikan path import LoginScreen di bawah ini sudah benar sesuai struktur folder kamu
import 'package:jamu_saripah/hooks/auth/login_screen.dart'; 
import 'package:jamu_saripah/screens/SettingsScreen/components/change_password_screen.dart';
import 'package:jamu_saripah/screens/SettingsScreen/components/notifications_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color primaryColor = const Color(0xFF8DA05E);
  final Color backgroundColor = const Color(0xFFF9FAf7);
  bool _isProcessing = false; // Loading state untuk proses async

  // --- 1. LOGIC: HAPUS CACHE ---
  Future<void> _handleDeleteCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      if (!mounted) return;
      _showSnackBar("Cache berhasil dibersihkan", Colors.green);
    } catch (e) {
      _showSnackBar("Gagal menghapus cache", Colors.red);
    }
  }

  // --- 2. LOGIC: HAPUS AKUN (VERIFIKASI PASSWORD) ---
  Future<void> _handleDeleteAccount(String password) async {
    if (password.isEmpty) {
      _showSnackBar("Password wajib diisi untuk verifikasi", Colors.orange);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null && user.email != null) {
        // Step 1: Re-autentikasi (Verifikasi bahwa ini benar-benar pemilik akun)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // Step 2: Hapus Akun dari Firebase Authentication
        await user.delete();

        if (!mounted) return;

        // Step 3: Navigasi ke Login (MENGGUNAKAN MaterialPageRoute AGAR TIDAK ERROR ROUTE)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()), 
          (route) => false,
        );
        
        _showSnackBar("Akun Anda berhasil dihapus secara permanen", Colors.black);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Terjadi kesalahan";
      
      if (e.code == 'wrong-password') {
        errorMessage = "Kata sandi salah! Akun gagal dihapus.";
      } else if (e.code == 'requires-recent-login') {
        errorMessage = "Sesi login berakhir. Silakan login ulang untuk menghapus akun.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Periksa koneksi internet Anda.";
      }
      
      _showSnackBar(errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar("Kesalahan sistem: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- 3. HELPER: SNACKBAR ---
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- 4. DIALOG: KONFIRMASI HAPUS AKUN ---
  void _showDeleteAccountDialog() {
    final TextEditingController pswdController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa klik luar saat proses sensitif
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Akun?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tindakan ini tidak bisa dibatalkan. Masukkan sandi Anda:"),
            const SizedBox(height: 15),
            TextField(
              controller: pswdController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Kata sandi",
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _handleDeleteAccount(pswdController.text.trim());
            },
            child: const Text("Konfirmasi Hapus", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                  },
                ),
                _buildSettingCard(
                  icon: Icons.delete_sweep_outlined,
                  title: "Hapus Cache",
                  subtitle: "Bersihkan ruang penyimpanan aplikasi",
                  color: primaryColor,
                  onTap: _handleDeleteCache,
                ),
                const SizedBox(height: 20),
                _buildSectionLabel("Zona Bahaya"),
                _buildSettingCard(
                  icon: Icons.person_remove_outlined,
                  title: "Hapus Akun",
                  subtitle: "Hapus data akun secara permanen",
                  color: Colors.redAccent,
                  onTap: _showDeleteAccountDialog,
                  isCritical: true,
                ),
              ],
            ),
          ),
          // Loading Overlay yang muncul saat _isProcessing bernilai true
          if (_isProcessing)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
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
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
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
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
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
}