import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan ini
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini
import 'package:jamu_saripah/screens/hooks/onBoarding/onboarding_screen.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  
  bool _isNameFocused = false;
  bool _isLoading = true; // State untuk loading indikator

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Ambil data saat halaman dimuat
    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
  }

  // --- LOGIKA FIREBASE ---

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    // 1. Cek apakah user sudah login di Firebase Auth
    if (user == null) {
      _showInvalidUserDialog();
      return;
    }

    try {
      // 2. Ambil data dari Firestore berdasarkan UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = user.email ?? ''; // Email biasanya dari Auth
          _phoneController.text = data['phone'] ?? '';
          _isLoading = false;
        });
      } else {
        // Jika di Auth ada tapi di Firestore tidak ada (Data tidak sinkron)
        _showInvalidUserDialog();
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _showInvalidUserDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Sesi Tidak Valid"),
        content: const Text("Akun Anda tidak ditemukan atau sesi telah berakhir. Silakan login kembali."),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Arahkan ke halaman login (sesuaikan dengan route name kamu)
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text("LOGOUT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // Update data ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _handleLogout() async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Konfirmasi Keluar"),
      content: const Text("Apakah Anda yakin ingin keluar dari akun Jamu Saripah?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("BATAL", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () async {
            try {
              // 1. Logout dari Firebase
              await FirebaseAuth.instance.signOut();
              
              // 2. Navigasi ke OnboardingScreen
              if (mounted) {
                // Pastikan nama route ini sesuai dengan yang ada di main.dart kamu
                // Biasanya menggunakan '/' untuk awal atau '/onboarding'
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()), 
                  (route) => false, // Menghapus semua history page sebelumnya
                );
              }
            } catch (e) {
              debugPrint("Error logout: $e");
            }
          },
          child: const Text(
            "KELUAR", 
            style: TextStyle(color: Color(0xFFA13333), fontWeight: FontWeight.bold)
          ),
        ),
      ],
    ),
  );
}

  // --- UI SECTION ---

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Akun Saya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF7B8B5C)))
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E3D3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Member sejak: 06 Februari 2026',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
            const SizedBox(height: 30),
            
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)]),
                  child: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF7B8B5C)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Lengkapi data dirimu sekarang dan dapatkan\nvoucher menarik di hari spesialmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF7B8B5C), fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 40),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  hint: 'Nama pengguna', 
                ),
                if (_isNameFocused)
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Text(
                      "*Nama pengguna hanya bisa diganti dalam 7 hari",
                      style: TextStyle(
                        color: Color(0xFF7B8B5C),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Email biasanya tidak boleh diganti sembarangan
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              hint: 'Nomor telpon',
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B8B5C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text('Simpan!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          TextButton.icon(
  onPressed: _handleLogout, // Panggil fungsi logout yang baru
  icon: const Icon(Icons.logout_outlined, color: Color(0xFFA13333), size: 20), // Ganti icon agar sesuai
  label: const Text(
    'LOG OUT', 
    style: TextStyle(
      color: Color(0xFFA13333), 
      fontWeight: FontWeight.bold, 
      letterSpacing: 1.1
    )
  ),
),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode, 
    required String hint, 
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
        ),
      ),
    );
  }
}