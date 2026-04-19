import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';

// TODO: Implementasi penyimpanan data menggunakan SharedPreferences atau database lokal lainnya untuk menyimpan perubahan profil pengguna.
// TODO: Tambahkan validasi input untuk memastikan data yang dimasukkan pengguna valid (misalnya, format email yang benar, nomor telepon yang valid, dll).
class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // 1. Tambahkan FocusNode untuk mendeteksi fokus pada nama pengguna
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameFocused = false;

  @override
  void initState() {
    super.initState();
    // 2. Tambahkan listener untuk memantau perubahan fokus
    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // 3. Jangan lupa dispose FocusNode
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _handleSave() {
    String name = _nameController.text;
    print("Data disimpan: $name");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Badge Member
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
            
            // Profile Picture
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

            // --- Form Field Nama Pengguna ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode, // 4. Pasang focusNode di sini
                  hint: 'Nama pengguna', 
                  isArrow: true,
                ),
                // 5. Logika tampilan: Muncul hanya jika _isNameFocused bernilai true
                if (_isNameFocused)
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Text(
                      "*Nama pengguna hanya bisa diganti dalam 7 hari",
                      style: TextStyle(
                        color: AppColors.primaryOlive,
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
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              hint: 'Nomor telpon',
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 60),

            // Button Simpan
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
              onPressed: () {},
              icon: const Icon(Icons.delete_outline, color: Color(0xFFA13333), size: 20),
              label: const Text('HAPUS AKUN', style: TextStyle(color: Color(0xFFA13333), fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Tambahkan parameter focusNode di build method
  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode, 
    required String hint, 
    bool isArrow = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: controller,
        focusNode: focusNode, // Pasang ke widget TextField
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,        ),
      ),
    );
  }
}