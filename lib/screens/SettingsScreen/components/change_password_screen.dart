import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isObscureOld = true;
  bool _isObscureNew = true;

  // --- LOGIC GANTI PASSWORD ---
  Future<void> _handleChangePassword() async {
    // Validasi input form (tidak boleh kosong)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null && user.email != null) {
        // 1. Re-authenticate: User wajib masukin password lama dulu
        // Ini syarat keamanan Firebase untuk tindakan sensitif
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);
        
        // 2. Jika berhasil, baru update ke password baru
        await user.updatePassword(_newPasswordController.text.trim());

        if (!mounted) return;
        _showSnackBar("Kata sandi berhasil diperbarui!", isError: false);
        
        // Tunggu sebentar lalu tutup halaman
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } on FirebaseAuthException catch (e) {
      // Handling error spesifik
      String errorMessage = "Terjadi kesalahan";
      if (e.code == 'wrong-password') {
        errorMessage = "Kata sandi lama yang Anda masukkan salah.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Kata sandi baru terlalu lemah (min. 6 karakter).";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Terlalu banyak percobaan. Coba lagi nanti.";
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar("Terjadi kesalahan sistem.", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red :AppColors.primaryOlive,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E8959), // Warna Hijau Olive kamu
      body: Column(
        children: [
          // Header dengan tombol Back
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Ubah Kata Sandi",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Masukkan sandi lama dan sandi baru Anda.",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 40),

                      // Field Password Lama
                      _buildTextField(
                        controller: _oldPasswordController,
                        hint: "Kata sandi lama",
                        isObscure: _isObscureOld,
                        onToggle: () => setState(() => _isObscureOld = !_isObscureOld),
                      ),
                      
                      const SizedBox(height: 20),

                      // Field Password Baru
                      _buildTextField(
                        controller: _newPasswordController,
                        hint: "Kata sandi baru",
                        isObscure: _isObscureNew,
                        onToggle: () => setState(() => _isObscureNew = !_isObscureNew),
                      ),

                      const SizedBox(height: 60),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7E8959),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _handleChangePassword,
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Simpan Perubahan",
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pendukung untuk Text Field agar kode tidak duplikat
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: (value) => value!.isEmpty ? "Bidang ini tidak boleh kosong" : null,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: onToggle,
        ),
      ),
    );
  }
}