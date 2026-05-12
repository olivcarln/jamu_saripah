import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final bool _rememberMe = false;
  bool _isObscure = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // FUNGSI REGISTER YANG SUDAH FIX (FIRESTORE + ROLE)
  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      _showSnackBar("Semua field wajib diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Membuat user di Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Update display name di Firebase Auth
      await userCredential.user?.updateDisplayName(username);

      // 3. SIMPAN DATA KE FIRESTORE (Mencegah Error "role" does not exist)
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'role': 'user', // ✅ Field "role" didaftarkan di sini
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showSnackBar("Akun berhasil dibuat!");

      // 4. Pindah ke MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _showSnackBar("Terjadi error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = "Email sudah digunakan";
        break;
      case 'weak-password':
        message = "Password terlalu lemah";
        break;
      case 'invalid-email':
        message = "Format email tidak valid";
        break;
      default:
        message = "Terjadi kesalahan: ${e.message}";
    }
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E8959),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerRight,
              child: const Text(
                "Butuh bantuan?",
                style: TextStyle(
                  color: Colors.white, 
                  decoration: TextDecoration.underline, 
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Bergabunglah dengan kami",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text("Gabung sekarang, dapatkan yang terbaik"),
                    const SizedBox(height: 25),
                    _buildTextField(
                      icon: Icons.email_outlined,
                      hint: "Email",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      icon: Icons.person_outline,
                      hint: "Nama pengguna",
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      icon: Icons.lock_outline,
                      hint: "Kata sandi",
                      isPassword: true,
                      obscureText: _isObscure,
                      controller: _passwordController,
                      onToggleVisibility: () => setState(() => _isObscure = !_isObscure),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7E8959),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Daftar", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah ada akun? "),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Color(0xFF7E8959),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: onToggleVisibility,
              )
            : null,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }
}